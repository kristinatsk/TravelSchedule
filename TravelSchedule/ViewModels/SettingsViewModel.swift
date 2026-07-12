import Foundation


@Observable
final class SettingsViewModel {
    var isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode") {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }
    
}
