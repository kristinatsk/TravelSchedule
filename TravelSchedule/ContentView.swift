import SwiftUI
import OpenAPIURLSession

struct ContentView: View {
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
        }
    }
    
    func testFetchStations() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                let service = NearestStationsService(
                    client: client,
                    apikey: "e0940f60-7b86-40f1-ba94-6a70f7d38166"
                )
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
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                let service = CopyrightService(
                    client: client,
                    apikey: "e0940f60-7b86-40f1-ba94-6a70f7d38166"
                )
                print("Fetching copyright...")
                let copyright = try await service.getCopyright(
                    format: "json"
                )
                print("Successfully fetched copyright \(copyright)")
            } catch {
                print("Error fetching copyright \(error)")
            }
        }
    }
    
    func testFetchSchedualBetweenStations() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                let service = SchedualBetweenStationsService(
                    client: client,
                    apikey: "e0940f60-7b86-40f1-ba94-6a70f7d38166"
                )
                print("Fetching schedual between stations...")
                
                let schedualBetweenStations = try await service.getSchedualBetweenStations(
                    from: "c213",
                    to: "c2"
                )
                print("Successfully fetched schedual between stations: \(schedualBetweenStations)")
            } catch {
                print("Error fetching copyright \(error)")
            }
        }
    }
}

#Preview {
    ContentView()
}
