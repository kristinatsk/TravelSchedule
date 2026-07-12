import Foundation

@Observable
final class StationsViewModel {
    private var allStationsService: AllStationsServiceProtocol

    init(allStationsService: AllStationsServiceProtocol) {
        self.allStationsService = allStationsService
    }
    
    var isLoading = true
    var allStations: AllStations? = nil
    var searchText = ""
    var stations: [Components.Schemas.Station] = []
    var searchResults: [Components.Schemas.Station] {
        if searchText.isEmpty {
            stations
        } else {
            stations.filter { station in (station.title ?? "").localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    private func getStations(allStations: AllStations) -> [Components.Schemas.Station] {
        let countries = allStations.countries ?? []
        let regions = countries.flatMap { $0.regions ?? [] }
        let settlements = regions.flatMap { $0.settlements ?? [] }
        let stations = settlements.flatMap { $0.stations ?? [] }
        
        return stations
        
    }
    
    func fetchStations() {
        Task {
            do {
                let stationsResponse = try await allStationsService.getAllStations()
                allStations = stationsResponse
                self.stations = getStations(allStations: stationsResponse)
                isLoading = false
            } catch {
                isLoading = false
            }
        }
    }
}
