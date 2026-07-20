import OpenAPIRuntime
import OpenAPIURLSession

typealias RouteStations = Components.Schemas.ThreadStationsResponse

protocol RouteStationsServiceProtocol {
    func getRouteStations(uid: String) async throws -> RouteStations
}

actor RouteStationsService: RouteStationsServiceProtocol {
    private let client: Client
    
    init(client: Client) { self.client = client }
    
    func getRouteStations(uid: String) async throws -> RouteStations {
        let response = try await client.getRouteStations(query: .init(uid: uid))
        
        return try await response.ok.body.json
    }
}
