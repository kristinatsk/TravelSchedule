import OpenAPIRuntime
import OpenAPIURLSession

typealias CarrierInfo = Components.Schemas.CarrierResponse

protocol CarrierInfoServiceProtocol {
    func getCarrierInfo(code: String) async throws -> CarrierInfo
}

actor CarrierInfoService: CarrierInfoServiceProtocol {
    private let client: Client
    
    init(client: Client) {
        self.client = client
    }
    
    func getCarrierInfo(code: String) async throws -> CarrierInfo {
        let response = try await client.getCarrierInfo(query: .init(code: code))
        
        return try await response.ok.body.json
    }
}
