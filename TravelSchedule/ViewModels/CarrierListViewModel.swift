import Foundation

@Observable
final class CarrierListViewModel {
    let selectedDepartureStation: String
    let selectedArrivalStation: String
    let departureCode: String
    let arrivalCode: String
    let scheduleBetweenStationsService: ScheduleBetweenStationsServiceProtocol
    
    init(selectedDepartureStation: String, selectedArrivalStation: String, departureCode: String, arrivalCode: String, scheduleBetweenStationsService: ScheduleBetweenStationsServiceProtocol) {
        self.selectedDepartureStation = selectedDepartureStation
        self.selectedArrivalStation = selectedArrivalStation
        self.departureCode = departureCode
        self.arrivalCode = arrivalCode
        self.scheduleBetweenStationsService = scheduleBetweenStationsService
    }

    
    var segments: [Components.Schemas.Segment] = []
    var selectedTimes: Set<DepartureTime> = []
    var showTransfers: Bool = true
    var currentViewState: ViewState = .loading
    
    var filteredSegments: [Components.Schemas.Segment] {
         segments.filter { segment in
             let matchTransfers = showTransfers ? true : ((segment.has_transfers ?? false) == false)
             var matchTime = true
             if !selectedTimes.isEmpty {
                 if let category = getDepartureTime(from: segment.departure ?? "") {
                     matchTime = selectedTimes.contains(category)
                 } else {
                     matchTime = false
                 }
                 
             }
             return matchTransfers && matchTime
         }
     }
    
    func formatTime(serverDate: String) -> String {
        return String(serverDate.prefix(5))
    }
    
    func formatDuration(seconds: Int) -> String {
        let hours = seconds / 3600
        
        return "\(hours) часов"
    }
    
    func getDepartureTime(from departureString: String) -> DepartureTime? {
        let hourString = String(departureString.prefix(2))
        guard let hour = Int(hourString) else { return nil }
        switch hour {
        case 0...5:
            return DepartureTime.night
        case 6...11:
            return DepartureTime.morning
        case 12...17:
            return DepartureTime.afternoon
        case 18...23:
            return DepartureTime.evening
        default: return nil
        }
    }
    
    
    func fetchedRoutes() {
        Task {
            do {
                let response = try await scheduleBetweenStationsService.getScheduleBetweenStations(from: departureCode, to: arrivalCode)
                let fetchedSegments = response.segments
                segments = fetchedSegments ?? []
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
