import SwiftUI
import OpenAPIURLSession

struct SelectCityView: View {
    @Environment(\.dismiss) var dismiss
    @State var searchText = ""
    @State var settlements: [Components.Schemas.Settlement] = []
    @Binding var selectedStation: String
    @Binding var selectedStationCode: String
    
    let stationsService: AllStationsService
    var searchResults: [Components.Schemas.Settlement] {
        if searchText.isEmpty {
            settlements
        } else {
            settlements.filter { city in (city.title ?? "").localizedCaseInsensitiveContains(searchText)}
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
            if !searchText.isEmpty && searchResults.isEmpty {
                Spacer()
                
                Text("Город не найден")
                    .font(.system(size: 24, weight: .bold))
                Spacer()
            } else {
                List {
                    ForEach(searchResults, id: \.self) { city in
                        NavigationLink {
                            SelectStationView(selectedStation: $selectedStation, selectedStationCode: $selectedStationCode, stations: city.stations ?? [])
                        } label: {
                            Text(city.title ?? "")
                        }
                        .foregroundColor(.black)
                    }
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
                var fetchedCities: [Components.Schemas.Settlement] = []
                for country in response.countries ?? [] {
                    for region in country.regions ?? [] {
                        for settlement in region.settlements ?? [] {
                            if let cityName = settlement.title, let settleName = settlement.stations {
                                fetchedCities.append(settlement)
                            }
                        }
                    }
                }
                settlements = fetchedCities
            } catch {
                print(error.localizedDescription)
            }
        }
        .onChange(of: selectedStation) { oldValue, newValue in
            dismiss()
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
        SelectCityView(selectedStation: .constant(""), selectedStationCode: .constant(""),stationsService: service)
    }
    
}
