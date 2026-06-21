import OpenAPIRuntime
import OpenAPIURLSession
import Foundation

typealias AllStations = Components.Schemas.AllStationsResponse

protocol AllStationsServiceProtocol {
    func getAllStations() async throws -> AllStations
}

final class AllStationsService: AllStationsServiceProtocol {
    
    private let client: Client
    
    init(client: Client) { self.client = client }
    
    func getAllStations() async throws -> AllStations {
        let response = try await client.getAllStations(query: .init())
        
        let responseBody = try response.ok.body.html
        
        let limit = 50 * 1024 * 1024
        
        var fullData = try await Data(collecting: responseBody, upTo: limit)
        
        let allStations = try JSONDecoder().decode(AllStations.self, from: fullData)
        
        
        return allStations
    }
}
