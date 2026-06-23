import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView() {
                RouteSearchView()
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
    MainTabView()
}
