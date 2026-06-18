import OpenAPIRuntime
import OpenAPIURLSession

typealias SchedualBetweenStations = Components.Schemas.Segments

protocol SchedualBetweenStationsServiceProtocol {
    func getSchedualBetweenStations(
        from: String,
        to: String,
        format: String?,
        lang: String?,
        date: String?,
        transportTypes: String?,
        offset: Int?,
        limit: Int?,
        resultTimezone: String?,
        transfers: Bool?
    ) async throws -> SchedualBetweenStations
}

final class SchedualBetweenStationsService: SchedualBetweenStationsServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getSchedualBetweenStations(
        from: String,
        to: String,
        format: String? = nil,
        lang: String? = nil,
        date: String? = nil,
        transportTypes: String? = nil,
        offset: Int? = nil,
        limit: Int? = nil,
        resultTimezone: String? = nil,
        transfers: Bool? = nil
    ) async throws -> SchedualBetweenStations {
        let response = try await client.getSchedualBetweenStations(query: .init(
            apikey: apikey,
            from: from,
            to: to,
            format: format,
            lang: lang,
            date: date,
            transport_types: transportTypes,
            offset: offset,
            limit: limit,
            result_timezone: resultTimezone,
            transfers: transfers
        ))
        
        return try response.ok.body.json
    }
}
