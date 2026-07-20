import Foundation

@Observable
final class CitiesViewModel {
    var searchText = ""
    var settlements: [Components.Schemas.Settlement] = []
    var currentViewState: ViewState = .loading
    var searchResults: [Components.Schemas.Settlement] {
        if searchText.isEmpty {
            settlements
        } else {
            settlements.filter { city in (city.title ?? "").localizedCaseInsensitiveContains(searchText) }
        }
    }
    var allCities: AllStations? = nil
    
    var stationsService: AllStationsServiceProtocol
    
    init(stationsService: AllStationsServiceProtocol) {
        self.stationsService = stationsService
    }
    
    func getCities(allCities: AllStations) -> [Components.Schemas.Settlement] {
        let countries = allCities.countries ?? []
        let regions = countries.flatMap { $0.regions ?? [] }
        let settlements = regions.flatMap { $0.settlements ?? [] }
        
        return settlements
    }
    
    func fetchCities() {
        Task {
            do {
                let citiesResponse = try await stationsService.getAllStations()
                allCities = citiesResponse
                self.settlements = getCities(allCities: citiesResponse)
                currentViewState = .success
            } catch {
                if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                    currentViewState = .noInternet
                } else {
                    currentViewState = .serverError
                }
                print(error.localizedDescription)
            }
        }
    }
}
