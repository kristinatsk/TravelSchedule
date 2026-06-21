import OpenAPIRuntime
import OpenAPIURLSession

typealias SchedualBetweenStations = Components.Schemas.Segments

protocol SchedualBetweenStationsServiceProtocol {
    func getSchedualBetweenStations( from: String, to: String) async throws -> SchedualBetweenStations
}

final class SchedualBetweenStationsService: SchedualBetweenStationsServiceProtocol {
    private let client: Client
    
    init(client: Client) { self.client = client }
    
    func getSchedualBetweenStations(from: String, to: String) async throws -> SchedualBetweenStations {
        let response = try await client.getSchedualBetweenStations(query: .init(
            from: from,
            to: to
        ))
        
        return try response.ok.body.json
    }
}
