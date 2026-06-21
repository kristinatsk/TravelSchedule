import OpenAPIRuntime
import OpenAPIURLSession

typealias RouteStations = Components.Schemas.ThreadStationsResponse

protocol RouteStationsServiceProtocol {
    func getRouteStations(uid: String) async throws -> RouteStations
}

final class RouteStationsService: RouteStationsServiceProtocol {
    private let client: Client
    
    init(client: Client) { self.client = client }
    
    func getRouteStations(uid: String) async throws -> RouteStations {
        let response = try await client.getRouteStations(query: .init(uid: uid))
        
        return try response.ok.body.json
    }
}
