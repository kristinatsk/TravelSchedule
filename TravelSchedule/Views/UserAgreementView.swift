import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
}

struct UserAgreementView: View {
        var body: some View {
            VStack {
                if let agreementURL = URL(string: "https://yandex.ru/legal/practicum_offer") {
                    WebView(url: agreementURL)
                }
            }
            .navigationTitle("Пользовательское соглашение")
            .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    UserAgreementView()
}
