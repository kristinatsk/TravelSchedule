import OpenAPIRuntime
import OpenAPIURLSession

typealias NearestCity = Components.Schemas.NearestCityResponse

protocol NearestCityServiceProtocol {
    func getNearestCity(lat: Double, lng: Double) async throws -> NearestCity
}

actor NearestCityService: NearestCityServiceProtocol {
    
    private let client: Client
    
    init(client: Client) { self.client = client }
    
    func getNearestCity(lat: Double, lng: Double) async throws -> NearestCity {
        let response = try await client.getNearestCity(query: .init(
            lat: lat,
            lng: lng
        ))
        return try await response.ok.body.json
    }
}
