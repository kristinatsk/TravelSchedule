import SwiftUI
import OpenAPIURLSession

struct MainTabView: View {
    let stationsService: AllStationsService
    let carrierInfoService: CarrierInfoService
    let scheduleBetweenStationsService: ScheduleBetweenStationsService
    
    var body: some View {
        TabView() {
            RouteSearchView(
                stationsService: stationsService,
                carrierInfoService: carrierInfoService,
                scheduleBetweenStationsService: scheduleBetweenStationsService
            )
            .tabItem {
                Image(.mainItem)
                    .renderingMode(.template)
            }
            
                SettingsView()
            .tabItem {
                Image(.settingsItem)
                    .renderingMode(.template)
            }
        }
        .tint(.primary)
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
        let scheduleBetweenStationsService = ScheduleBetweenStationsService(client: client)
    
    
    return MainTabView(
        stationsService: service,
        carrierInfoService: carrierInfoService,
        scheduleBetweenStationsService: scheduleBetweenStationsService
    )
    
}
