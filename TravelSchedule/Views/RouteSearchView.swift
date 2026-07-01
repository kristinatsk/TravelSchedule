import SwiftUI
import OpenAPIURLSession

struct RouteSearchView: View {
    let carrierInfoService: CarrierInfoService
    let schedualBetweenStationsService: SchedualBetweenStationsService
    
    @State private var departureCity = ""
    @State private var arrivalCity = ""
    @State private var departureStationCode = ""
    @State private var arrivalStationCode = ""
    
    let stationsService: AllStationsService
    var body: some View {
        NavigationStack {
            VStack {
                Color.clear.frame(height: 188)
                HStack {
                    VStack(alignment: .leading, spacing: 14) {
                        NavigationLink {
                            SelectCityView(selectedStation: $departureCity,  selectedStationCode: $departureStationCode, stationsService: stationsService)
                        } label: {
                            if departureCity.isEmpty {
                                Text("Откуда")
                            } else {
                                Text(departureCity)
                                    .foregroundColor(.black)
                            }
                        }
                        
                        NavigationLink {
                            SelectCityView(selectedStation: $arrivalCity, selectedStationCode: $arrivalStationCode, stationsService: stationsService)
                        } label: {
                            if arrivalCity.isEmpty {
                                Text("Куда")
                            } else {
                                Text(arrivalCity)
                                    .foregroundColor(.black)
                            }
                        }
                        
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.grayUniversal)
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .buttonStyle(.plain)
                    
                    Button {
                        (departureCity, arrivalCity) = (arrivalCity, departureCity)
                    } label: {
                        Image(.сhange)
                            .foregroundColor(.white)
                    }
                    
                    
                }
                .padding()
                .background(.blueUniversal)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding()
                
                if !departureCity.isEmpty && !arrivalCity.isEmpty {
                    NavigationLink {
                        CarrierListView(
                            selectedDepartureStation: departureCity,
                            selectedArrivalStation: arrivalCity,
                            departureCode: departureStationCode,
                            arrivalCode: arrivalStationCode,
                            carrierInfoService: carrierInfoService,
                            schedualBetweenStationsService: schedualBetweenStationsService
                        )
                    } label: {
                        Text("Найти")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 150)
                            .padding()
                            .background(.blueUniversal)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
                Spacer()
                
            }
            
            
            
        }
    }
}

#Preview {
    let safeURL: URL
    
    do {
        safeURL = try Servers.Server1.url()
    } catch {
        safeURL = URL(string: "https://yandex.ru")!
    }
    
    let client = Client(
        serverURL: safeURL,
        transport: URLSessionTransport(),
        middlewares: [AuthenticationMiddleware(apikey: "e0940f60-7b86-40f1-ba94-6a70f7d38166")]
    )
    
    let service = AllStationsService(client: client)
    let carrierInfoService = CarrierInfoService(client: client)
    let schedualBetweenStationsService = SchedualBetweenStationsService(client: client)
    
    
    return RouteSearchView(
        carrierInfoService: carrierInfoService,
        schedualBetweenStationsService: schedualBetweenStationsService,
        stationsService: service
    )
    
}
