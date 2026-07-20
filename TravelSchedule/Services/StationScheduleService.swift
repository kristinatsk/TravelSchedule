import OpenAPIRuntime
import OpenAPIURLSession

typealias StationSchedule = Components.Schemas.ScheduleResponse

protocol StationScheduleServiceProtocol {
    func getStationSchedule(station: String) async throws -> StationSchedule
}

actor StationScheduleService: StationScheduleServiceProtocol {
    private let client: Client
    
    init(client: Client) { self.client = client }
    
    func getStationSchedule(station: String) async throws -> StationSchedule {
        let response = try await client.getStationSchedule(query: .init(
            station: station
        ))
        
        return try await response.ok.body.json
    }
   
}
