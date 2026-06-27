import SwiftUI
import OpenAPIURLSession

struct CarrierListView: View {
    
    let selectedDepartureStation: String
    let selectedArrivalStation: String
    let departureCode: String
    let arrivalCode: String
    let carrierInfoService: CarrierInfoService
    let schedualBetweenStationsService: SchedualBetweenStationsService
    
    @State var segments: [Components.Schemas.Segment] = []
    
    var body: some View {
        VStack {
            Text("\(selectedDepartureStation) -> \(selectedArrivalStation)")
                .font(.system(size: 24, weight: .bold))
            ScrollView {
                VStack (spacing: 14) {
                    ForEach(segments, id: \.self) { segment in
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
                                    Text(segment.thread?.carrier?.title ?? "")
                                        .foregroundColor(.black)
                                        .font(.system(size: 17, weight: .regular))
                                        
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
        .task {
            do {
                let response = try await schedualBetweenStationsService.getSchedualBetweenStations(from: departureCode, to: arrivalCode)
                let fetchedSegments = response.segments
                segments = fetchedSegments ?? []
            } catch {
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
