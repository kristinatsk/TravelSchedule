import OpenAPIRuntime
import OpenAPIURLSession

typealias ScheduleBetweenStations = Components.Schemas.Segments

protocol ScheduleBetweenStationsServiceProtocol {
    func getScheduleBetweenStations( from: String, to: String) async throws -> ScheduleBetweenStations
}

actor ScheduleBetweenStationsService: ScheduleBetweenStationsServiceProtocol {
    private let client: Client
    
    init(client: Client) { self.client = client }
    
    func getScheduleBetweenStations(from: String, to: String) async throws -> ScheduleBetweenStations {
        let response = try await client.getScheduleBetweenStations(query: .init(
            from: from,
            to: to
        ))
        
        return try await response.ok.body.json
    }
}
