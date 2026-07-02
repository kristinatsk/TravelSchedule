import SwiftUI

struct OnboardingView: View {
    @AppStorage(Constants.Storage.hasSeenOnboarding) var hasSeenOnboarding = false
    var body: some View {
        Image(.splashScreen)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
            .onAppear {
                Task {
                    try? await Task.sleep(for: .seconds(2))
                    hasSeenOnboarding = true
                }
            }
    }
}

#Preview {
    OnboardingView()
}
