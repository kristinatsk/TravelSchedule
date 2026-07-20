import Foundation

@Observable
final class RouteSearchViewModel {
    let carrierInfoService: CarrierInfoServiceProtocol
    let scheduleBetweenStationsService: ScheduleBetweenStationsServiceProtocol
    let stationsService: AllStationsServiceProtocol
    
    var departureCity = ""
    var arrivalCity = ""
    var departureStationCode = ""
    var arrivalStationCode = ""
    var selectedStory: Story?
    var stories = Story.mockData
    
    init(carrierInfoService: CarrierInfoServiceProtocol, scheduleBetweenStationsService: ScheduleBetweenStationsServiceProtocol, stationsService: AllStationsServiceProtocol) {
        self.carrierInfoService = carrierInfoService
        self.scheduleBetweenStationsService = scheduleBetweenStationsService
        self.stationsService = stationsService
    }
    
    func reverseRoute() {
        (departureCity, arrivalCity) = (arrivalCity, departureCity)
        (departureStationCode, arrivalStationCode) = (arrivalStationCode, departureStationCode)
    }
}
