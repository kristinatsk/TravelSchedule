import SwiftUI
import OpenAPIURLSession

struct CarrierDetailView: View {
    let carrierCode: Int
    let carrierInfoService: CarrierInfoService
    var body: some View {
        Text("CarrierDetailView")
    }
}

#Preview {
    let client = Client(
        serverURL: try! Servers.Server1.url(),
        transport: URLSessionTransport(),
        middlewares: [AuthenticationMiddleware(apikey: "e0940f60-7b86-40f1-ba94-6a70f7d38166")]
    )
    let service = CarrierInfoService(client: client)
    
   return CarrierDetailView(
    carrierCode: 123,
    carrierInfoService: service
   )
}
