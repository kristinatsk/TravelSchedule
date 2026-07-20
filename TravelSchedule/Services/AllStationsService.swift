import OpenAPIRuntime
import OpenAPIURLSession
import Foundation

typealias AllStations = Components.Schemas.AllStationsResponse

protocol AllStationsServiceProtocol {
    func getAllStations() async throws -> AllStations
}

actor AllStationsService: AllStationsServiceProtocol {
    private let jsonDecoder = JSONDecoder()
    private let client: Client
    
    init(client: Client) { self.client = client }
    
    func getAllStations() async throws -> AllStations {
        let response = try await client.getAllStations(query: .init())
        
        let responseBody = try await response.ok.body.html
        
        let limit = 50 * 1024 * 1024
        
        let fullData = try await Data(collecting: responseBody, upTo: limit)
       
        let allStations = try await MainActor.run {
            return try jsonDecoder.decode(AllStations.self, from: fullData)
        }
        
        
        
        return allStations
    }
}


