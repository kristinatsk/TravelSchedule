import SwiftUI
import OpenAPIURLSession

struct RouteSearchView: View {
    @State var departureCity = ""
    @State var arrivalCity = ""
    let stationsService: AllStationsService
    var body: some View {
        NavigationStack {
            VStack {
                Color.clear.frame(height: 188)
                HStack {
                    VStack(alignment: .leading, spacing: 14) {
                        NavigationLink {
                            SelectCityView(selectedStation: $departureCity,  stationsService: stationsService)
                        } label: {
                            if departureCity.isEmpty {
                                Text("Откуда")
                            } else {
                                Text(departureCity)
                                    .foregroundColor(.black)
                            }
                        }
                        
                        NavigationLink {
                            SelectCityView(selectedStation: $arrivalCity, stationsService: stationsService)
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
                    .cornerRadius(20)
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
                .cornerRadius(20)
                .padding()
                Spacer()
            }
            
        }
    }
}

#Preview {
    let client = Client(
        serverURL: try! Servers.Server1.url(),
        transport: URLSessionTransport(),
        middlewares: [AuthenticationMiddleware(apikey: "e0940f60-7b86-40f1-ba94-6a70f7d38166")]
        )
        let service = AllStationsService(client: client)
    
    
    return RouteSearchView(stationsService: service)
    
}
