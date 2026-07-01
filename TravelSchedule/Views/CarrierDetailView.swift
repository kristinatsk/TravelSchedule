import SwiftUI
import OpenAPIURLSession

struct CarrierDetailView: View {
    let carrierCode: Int
    let carrierInfoService: CarrierInfoService
    @State private var currentViewState: ViewState = .loading
    
    var body: some View {
        Group {
            switch currentViewState {
            case .loading:
                ProgressView()
            case .success:
                Text("CarrierDetailView")
            case .noInternet:
                VStack {
                    Image(.noInternet)
                        .resizable()
                        .frame(width: 223, height: 223)
                        .clipShape(Circle())
                    Text("Нет интернета")
                        .font(.system(size: 24, weight: .bold))
                }
            case .serverError:
                VStack {
                    Image(.serverError)
                        .resizable()
                        .frame(width: 223, height: 223)
                        .clipShape(Circle())
                    Text("Ошибка сервера")
                        .font(.system(size: 24, weight: .bold))
                }
            }
            
        }
        .task {
            do {
                try await Task.sleep(for: .seconds(1))
                currentViewState = .success
            } catch {
                if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                    currentViewState = .noInternet
                } else {
                    currentViewState = .serverError
                }
                print(error.localizedDescription)
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
    let service = CarrierInfoService(client: client)
    
    return CarrierDetailView(
        carrierCode: 123,
        carrierInfoService: service
    )
}
