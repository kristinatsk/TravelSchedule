import SwiftUI
import OpenAPIURLSession

enum ViewState {
    case loading
    case success
    case noInternet
    case serverError
}

struct CarrierListView: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel: CarrierListViewModel
    
    init(
        scheduleBetweenStationsService: ScheduleBetweenStationsServiceProtocol,
        selectedDepartureStation: String,
        selectedArrivalStation: String,
        departureCode: String,
        arrivalCode: String
    ) {
        self._viewModel = State(
            initialValue: CarrierListViewModel(
                selectedDepartureStation: selectedDepartureStation,
                selectedArrivalStation: selectedArrivalStation,
                departureCode: departureCode,
                arrivalCode: arrivalCode,
                scheduleBetweenStationsService: scheduleBetweenStationsService
            ))
    }
    
    var body: some View {
        Group {
            switch viewModel.currentViewState {
            case .loading:
                ProgressView()
            case .success:
                VStack {
                    Text("\(viewModel.selectedDepartureStation) -> \(viewModel.selectedArrivalStation)")
                        .font(.system(size: 24, weight: .bold))
                        .padding(16)
                    ZStack(alignment: .bottom) {
                        if viewModel.filteredSegments.isEmpty {
                            Text("Вариантов нет")
                                .font(.system(size: 24, weight: .bold))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            ScrollView {
                                VStack (spacing: 8) {
                                    ForEach(viewModel.filteredSegments, id: \.self) { segment in
                                        if let carrier = segment.thread?.carrier {
                                            NavigationLink {
                                                CarrierDetailView(carrier: carrier)
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
                                                        .clipShape(RoundedRectangle(cornerRadius: 12))
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
                                                        Text(viewModel.formatTime(serverDate: segment.departure ?? ""))
                                                            .foregroundColor(.black)
                                                            .font(.system(size: 17, weight: .regular))
                                                        Rectangle()
                                                            .frame(height: 1)
                                                            .foregroundColor(.black)
                                                        
                                                        Text(viewModel.formatDuration(seconds: segment.duration ?? 0))
                                                            .font(.system(size: 12, weight: .regular))
                                                        Rectangle()
                                                            .frame(height: 1)
                                                            .foregroundColor(.black)
                                                        
                                                        Text(viewModel.formatTime(serverDate: segment.arrival ?? ""))
                                                            .font(.system(size: 17, weight: .regular))
                                                        
                                                    }
                                                    .foregroundColor(.black)
                                                    
                                                }
                                                .padding()
                                                .background(.lightGray)
                                                .clipShape(RoundedRectangle(cornerRadius: 24))
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        
                        NavigationLink {
                            FilterView(
                                selectedTimes: $viewModel.selectedTimes,
                                showTransfers: $viewModel.showTransfers
                            )
                        } label: {
                            HStack {
                                Text("Уточнить время")
                                if !viewModel.showTransfers || !viewModel.selectedTimes.isEmpty {
                                    Circle().fill(.redUniversal).frame(width: 8, height: 8)
                                }
                                
                            }
                            .foregroundColor(.white)
                            .font(.system(size: 17, weight: .bold))
                            .frame(maxWidth: .infinity, maxHeight: 60)
                            .background(.blueUniversal)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        
                        .padding(16)
                    }
                    
                }
            case .serverError:
                VStack {
                    Image(.serverError)
                        .resizable()
                        .frame(width: 223, height: 223)
                        .clipShape(Circle())
                    Text("Ошибка сервера")
                        .font(.system(size: 24, weight: .bold))
                }
                Divider()
            case .noInternet:
                VStack {
                    Image(.noInternet)
                        .resizable()
                        .frame(width: 223, height: 223)
                        .clipShape(Circle())
                    Text("Нет интернета")
                        .font(.system(size: 24, weight: .bold))
                }
                Divider()
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden()
        .toolbar() {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: Constants.Icons.chevronLeft)
                        .foregroundColor(.primary)
                }
            }
        }
        .task {
            viewModel.fetchedRoutes()
        }
    }
}

#Preview {
    
    let fallbackURL = URL(string: "https://yandex.ru") ?? URL(fileURLWithPath: "/")
    let safeURL = (try? Servers.Server1.url()) ?? fallbackURL
    
    let client = Client(
        serverURL: safeURL,
        transport: URLSessionTransport(),
        middlewares: [AuthenticationMiddleware(apikey: "e0940f60-7b86-40f1-ba94-6a70f7d38166")]
    )
    
    let scheduleService = ScheduleBetweenStationsService(client: client)
    
    CarrierListView(
        scheduleBetweenStationsService: scheduleService,
        selectedDepartureStation: "Москва",
        selectedArrivalStation: "Санкт-Петербург",
        departureCode: "c146",
        arrivalCode: "c213"
    )
}
