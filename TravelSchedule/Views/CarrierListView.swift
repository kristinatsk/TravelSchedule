import SwiftUI
import OpenAPIURLSession

enum ViewState {
    case loading
    case success
    case noInternet
    case serverError
}

struct CarrierListView: View {
    
    let selectedDepartureStation: String
    let selectedArrivalStation: String
    let departureCode: String
    let arrivalCode: String
    let carrierInfoService: CarrierInfoService
    let schedualBetweenStationsService: SchedualBetweenStationsService
    
    @State var segments: [Components.Schemas.Segment] = []
    @State var selectedTimes: Set<DepartureTime> = []
    @State var showTransfers: Bool = true
    @State var currentViewState: ViewState = .loading
    
    var filteredSegments: [Components.Schemas.Segment] {
        return segments.filter { segment in
            let matchTransfers = showTransfers ? true : ((segment.has_transfers ?? false) == false)
            var matchTime = true
            if !selectedTimes.isEmpty {
                if let category = getDepartureTime(from: segment.departure ?? "") {
                    matchTime = selectedTimes.contains(category)
                } else {
                    matchTime = false
                }
                
            }
            return matchTransfers && matchTime
        }
    }
    
    var body: some View {
        Group {
            switch currentViewState {
            case .loading:
                ProgressView()
            case .success:
                VStack {
                    Text("\(selectedDepartureStation) -> \(selectedArrivalStation)")
                        .font(.system(size: 24, weight: .bold))
                    ZStack(alignment: .bottom) {
                        if filteredSegments.isEmpty {
                            Text("Вариантов нет")
                                .font(.system(size: 24, weight: .bold))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            ScrollView {
                                VStack (spacing: 14) {
                                    ForEach(filteredSegments, id: \.self) { segment in
                                        NavigationLink {
                                            CarrierDetailView(
                                                carrierCode: segment.thread?.carrier?.code ?? 0,
                                                carrierInfoService: carrierInfoService
                                                
                                            )
                                        } label: {
                                            VStack(alignment: .leading, spacing: 18) {
                                                HStack(alignment: .top) {
                                                    AsyncImage(url: URL(string: segment.thread?.carrier?.logo ?? "")) { image in
                                                        
                                                        image
                                                            .resizable()
                                                            .scaledToFit()
                                                    } placeholder: {
                                                        Color.grayUniversal
                                                    }
                                                    .frame(width: 38, height: 38)
                                                    .cornerRadius(12)
                                                    VStack(alignment: .leading) {
                                                        Text(segment.thread?.carrier?.title ?? "")
                                                            .foregroundColor(.black)
                                                            .font(.system(size: 17, weight: .regular))
                                                        if segment.has_transfers == true {
                                                            Text("С пересадкой в Костроме")
                                                                .font(.system(size: 12, weight: .regular))
                                                                .foregroundColor(.redUniversal)
                                                        }
                                                    }
                                                    
                                                    Spacer()
                                                    Text("14 января")
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 12, weight: .regular))
                                                }
                                                HStack {
                                                    Text(formatTime(serverDate: segment.departure ?? ""))
                                                        .foregroundColor(.black)
                                                        .font(.system(size: 17, weight: .regular))
                                                    Rectangle()
                                                        .frame(height: 1)
                                                        .foregroundColor(.black)
                                                    
                                                    Text(formatDuration(seconds: segment.duration ?? 0))
                                                        .font(.system(size: 12, weight: .regular))
                                                    Rectangle()
                                                        .frame(height: 1)
                                                        .foregroundColor(.black)
                                                    
                                                    Text(formatTime(serverDate: segment.arrival ?? ""))
                                                        .font(.system(size: 17, weight: .regular))
                                                    
                                                }
                                                .foregroundColor(.black)
                                                
                                            }
                                            .padding()
                                            .background(.lightGray)
                                            .cornerRadius(24)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        
                        NavigationLink {
                            FilterView(
                                selectedTimes: $selectedTimes,
                                showTransfers: $showTransfers
                            )
                        } label: {
                            HStack {
                                Text("Уточнить время")
                                if showTransfers == false || !selectedTimes.isEmpty {
                                    Circle().fill(.redUniversal).frame(width: 8, height: 8)
                                }
                                
                            }
                            .foregroundColor(.white)
                            .font(.system(size: 17, weight: .bold))
                            .frame(maxWidth: .infinity, maxHeight: 60)
                            .background(.blueUniversal)
                            .cornerRadius(16)
                        }
                        
                        .padding(16)
                    }
                    
                }
            case .serverError:
                VStack {
                    Image(.serverError)
                        .resizable()
                        .frame(width: 223, height: 223)
                        .cornerRadius(70)
                    Text("Ошибка сервера")
                        .font(.system(size: 24, weight: .bold))
                }
            case .noInternet:
                VStack {
                    Image(.noInternet)
                        .resizable()
                        .frame(width: 223, height: 223)
                        .cornerRadius(70)
                    Text("Нет интернета")
                        .font(.system(size: 24, weight: .bold))
                }
            }
        }
        .task {
            do {
                let response = try await schedualBetweenStationsService.getSchedualBetweenStations(from: departureCode, to: arrivalCode)
                let fetchedSegments = response.segments
                segments = fetchedSegments ?? []
                currentViewState = .success
            } catch {
                if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                    currentViewState = .noInternet
                } else {
                    currentViewState = .serverError
                }
                print(error.localizedDescription)
            }
        }
    }
    
    func formatTime(serverDate: String) -> String {
        return String(serverDate.prefix(5))
    }
    
    func formatDuration(seconds: Int) -> String {
        let hours = seconds / 3600
        
        return "\(hours) часов"
    }
    
    func getDepartureTime(from departureString: String) -> DepartureTime? {
        let hourString = String(departureString.prefix(2))
        guard let hour = Int(hourString) else { return nil }
        switch hour {
        case 0...5:
            return DepartureTime.night
        case 6...11:
            return DepartureTime.morning
        case 12...17:
            return DepartureTime.afternoon
        case 18...23:
            return DepartureTime.evening
        default: return nil
        }
    }
}

#Preview {
    let client = Client(
        serverURL: try! Servers.Server1.url(),
        transport: URLSessionTransport(),
        middlewares: [AuthenticationMiddleware(apikey: "e0940f60-7b86-40f1-ba94-6a70f7d38166")]
    )
    let service = CarrierInfoService(client: client)
    let schedualService = SchedualBetweenStationsService(client: client)
    
    return CarrierListView(
        selectedDepartureStation: "Москва",
        selectedArrivalStation: "Санкт-Петербург",
        departureCode: "c146",
        arrivalCode: "c213",
        carrierInfoService: service,
        schedualBetweenStationsService: schedualService
    )
}
