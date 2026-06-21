import SwiftUI
import OpenAPIURLSession

struct ContentView: View {
    let client = Client(
        serverURL: try! Servers.Server1.url(),
        transport: URLSessionTransport(),
        middlewares: [AuthenticationMiddleware(apikey: "e0940f60-7b86-40f1-ba94-6a70f7d38166")]
    )
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            testFetchStations()
            testFetchCopyright()
            testFetchSchedualBetweenStations()
            testFetchStationSchedule()
            testFetchRouteStations()
            testFetchNearestCity()
            testFetchCarrierInfo()
            testFetchAllStations()
        }
    }
    
    func testFetchStations() {
        Task {
            do {
    
                let service = NearestStationsService(client: client)
                print("Fetching stations...")
                let stations = try await service.getNearestStations(
                    lat: 59.864177,
                    lng: 30.319163,
                    distance: 50
                )
                print("Successfully fetched stations: \(stations)")
            } catch {
                print("Error fetching stations \(error)")
            }
        }
    }
    
    func testFetchCopyright() {
        Task {
            do {
                let service = CopyrightService(client: client)
                print("Fetching copyright...")
                let copyright = try await service.getCopyright()
                print("Successfully fetched copyright \(copyright)")
            } catch {
                print("Error fetching copyright \(error)")
            }
        }
    }
    
    func testFetchSchedualBetweenStations() {
        Task {
            do {
                let service = SchedualBetweenStationsService(client: client)
                print("Fetching schedual between stations...")
                
                let schedualBetweenStations = try await service.getSchedualBetweenStations(
                    from: "c146",
                    to: "c213"
                )
                print("Successfully fetched schedual between stations: \(schedualBetweenStations)")
            } catch {
                print("Error fetching schedual between stations \(error)")
            }
        }
    }
    
    func testFetchStationSchedule() {
        Task {
            do {
                let service = StationScheduleService(client: client)
                print("Fetching station schedule...")
                
                let stationSchedule = try await service.getStationSchedule(
                    station: "s9600213")
                print("Successfully fetched station schedule: \(stationSchedule)")
            } catch {
                print("Error fetching station schedule \(error)")
            }
        }
    }
    
    func testFetchRouteStations() {
        Task {
            do {
                let service = RouteStationsService(client: client)
                print("Fetching route stations...")
                
                let routeStations = try await service.getRouteStations(uid: "SU-536_261028_c26_12")
                print("Successfully fetched route stations: \(routeStations)")
                
            } catch {
                print("Error fetching route stations \(error)")
            }
        }
    }
    
    func testFetchNearestCity() {
        Task {
            do {
                let service = NearestCityService(client: client)
                print("Fetching nearest city...")
                let nearestCity = try await service.getNearestCity(
                    lat: 59.864177,
                    lng: 30.319163
                )
                print("Successfully fetched nearest city: \(nearestCity)")
            } catch {
                print("Error fetching nearest city \(error)")
            }
        }
    }
    func testFetchCarrierInfo() {
        Task {
            do {
                let service = CarrierInfoService(client: client)
                print("Fetching carrier info ...")
                
                let carrierInfo = try await service.getCarrierInfo(code: "112")
                print("Successfully fetched carrier info \(carrierInfo)")
            } catch {
                print("Error fetching carrier info \(error)")
            }
        }
    }
    
    func testFetchAllStations() {
        Task {
            do {
                let service = AllStationsService(client: client)
                print("Fetching all stations ...")
                
                let allStations = try await service.getAllStations()
                print("Successfully fetched all stations. Countries count: \(allStations.countries?.count ?? 0)")
            } catch {
                print("Error fetching all stations \(error)")
            }
        }
    }
}

#Preview {
    ContentView()
}
