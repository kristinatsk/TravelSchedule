import SwiftUI
import OpenAPIURLSession

struct SelectCityView: View {
    @State var searchText = ""
    @State var cities: [String] = []
    let stationsService: AllStationsService
    var searchResults: [String] {
        if searchText.isEmpty {
            cities
        } else {
            cities.filter { city in city.contains(searchText)}
        }
    }
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Введите запрос", text: $searchText)
            }
            .padding()
            .background(.lightGray)
            .cornerRadius(10)
            List {
                    ForEach(searchResults, id: \.self) { city in
                        NavigationLink {
                            SelectStationView()
                        } label: {
                            Text(city)
                        }
                        .foregroundColor(.black)
                    }
                }
            }
            .padding()
            .listStyle(.plain)
            .navigationTitle("Выбор города")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                do {
                    let response = try await stationsService.getAllStations()
                    var fetchedCities: [String] = []
                    for country in response.countries ?? [] {
                        for region in country.regions ?? [] {
                            for settlement in region.settlements ?? [] {
                                if let cityName = settlement.title {
                                    fetchedCities.append(cityName)
                                }
                            }
                        }
                    }
                    cities = fetchedCities
                } catch {
                    print(error.localizedDescription)
                }
            }
    }
}

#Preview {
        let client = Client(
            serverURL: try! Servers.Server1.url(),
            transport: URLSessionTransport(),
            middlewares: [AuthenticationMiddleware(apikey: "e0940f60-7b86-40f1-ba94-6a70f7d38166")]
            )
            let service = AllStationsService(client: client)
        
    return NavigationStack {
        SelectCityView(stationsService: service)
    }
    
}
