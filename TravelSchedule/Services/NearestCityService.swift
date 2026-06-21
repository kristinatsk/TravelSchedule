import OpenAPIRuntime
import OpenAPIURLSession

typealias NearestCity = Components.Schemas.NearestCityResponse

protocol NearestCityServiceProtocol {
    func getNearestCity(lat: Double, lng: Double) async throws -> NearestCity
}

final class NearestCityService: NearestCityServiceProtocol {
    
    private let client: Client
    
    init(client: Client) { self.client = client }
    
    func getNearestCity(lat: Double, lng: Double) async throws -> NearestCity {
        let response = try await client.getNearestCity(query: .init(
            lat: lat,
            lng: lng
        ))
        return try response.ok.body.json
    }
}
