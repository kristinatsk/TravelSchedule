import SwiftUI
import OpenAPIURLSession

struct SelectCityView: View {
    @Environment(\.dismiss) var dismiss
    @State var searchText = ""
    @State var settlements: [Components.Schemas.Settlement] = []
    @State var currentViewState: ViewState = .loading
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
        Group {
            switch currentViewState {
            case .loading:
                ProgressView()
            case .success:
                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Введите запрос", text: $searchText)
                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.grayUniversal)
                            }
                        }
                    }
                    .padding()
                    .background(.searchBarBackground)
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
                                .foregroundColor(.primary)
                            }
                        }
                    }
                }
                .padding()
                .listStyle(.plain)
                .navigationTitle("Выбор города")
                .navigationBarTitleDisplayMode(.inline)
            case .serverError:
                VStack {
                    Image(.serverError)
                        .resizable()
                        .frame(width: 223, height: 223)
                        .cornerRadius(70)
                    Text("Ошибка сервера")
                        .font(.system(size: 24, weight: .bold))
                }
            case .noInternet:
                VStack {
                    Image(.noInternet)
                        .resizable()
                        .frame(width: 223, height: 223)
                        .cornerRadius(70)
                    Text("Нет интернета")
                        .font(.system(size: 24, weight: .bold))
                }
            }
        }
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
