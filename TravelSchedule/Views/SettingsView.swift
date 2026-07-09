import SwiftUI

struct SettingsView: View {
    @AppStorage(Constants.Storage.isDarkMode) var isDarkMode = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Toggle("Темная тема", isOn: $isDarkMode)
                        .tint(.blueUniversal)
                        .padding(.vertical, 9)
                    ZStack {
                        HStack {
                            Text("Пользовательское соглашение")
                            Spacer()
                            Image(systemName: Constants.Icons.chevronRight)
                                .foregroundColor(.primary)
                        }
                        NavigationLink {
                            UserAgreementView()
                        } label: {
                            Color.clear
                        }
                        .opacity(0)
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .padding(.top, 19)
                
                VStack(spacing: 16) {
                    Text("Приложение использует API «Яндекс.Расписания»")
                        .foregroundColor(.primary)
                    Text("Версия 1.0 (beta)")
                }
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.primary)
                .padding(.bottom, 24)
                Divider()

            }
        }
    }
}

#Preview {
    SettingsView()
}
