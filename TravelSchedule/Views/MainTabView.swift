import SwiftUI
import OpenAPIURLSession

struct MainTabView: View {
    let stationsService: AllStationsService
    var body: some View {
        TabView() {
            RouteSearchView(stationsService: stationsService)
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
        .tint(.black)
    }
}

#Preview {
    let client = Client(
        serverURL: try! Servers.Server1.url(),
        transport: URLSessionTransport(),
        middlewares: [AuthenticationMiddleware(apikey: "e0940f60-7b86-40f1-ba94-6a70f7d38166")]
        )
        let service = AllStationsService(client: client)
    
    
    return MainTabView(stationsService: service)
    
}
