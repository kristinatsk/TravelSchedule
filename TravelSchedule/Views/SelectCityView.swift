import SwiftUI
import OpenAPIURLSession

struct SelectCityView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @State private var settlements: [Components.Schemas.Settlement] = []
    @State private var currentViewState: ViewState = .loading
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
                    .padding(8)
                    .background(.searchBarBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
                    if !searchText.isEmpty && searchResults.isEmpty {
                        Spacer()
                        
                        Text("Город не найден")
                            .font(.system(size: 24, weight: .bold))
                        Spacer()
                    } else {
                        List {
                            ForEach(searchResults, id: \.self) { city in
                                ZStack {
                                    HStack {
                                        Text(city.title ?? "")
                                            .frame(height: 60)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.primary)
                                    }
                                    NavigationLink {
                                        SelectStationView(selectedStation: $selectedStation, selectedStationCode: $selectedStationCode, stations: city.stations ?? [])
                                    } label: {

                                        Color.clear
                                    }
                                }
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Выбор города")
                .navigationBarTitleDisplayMode(.inline)
            case .serverError:
                VStack {
                    Image(.serverError)
                        .resizable()
                        .frame(width: 223, height: 223)
                        .clipShape(Circle())
                    Text("Ошибка сервера")
                        .font(.system(size: 24, weight: .bold))
                }
            case .noInternet:
                VStack {
                    Image(.noInternet)
                        .resizable()
                        .frame(width: 223, height: 223)
                        .clipShape(Circle())
                    Text("Нет интернета")
                        .font(.system(size: 24, weight: .bold))
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden()
        .toolbar() {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
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
    let safeURL: URL
    
    do {
        safeURL = try Servers.Server1.url()
    } catch {
        safeURL = URL(string: "https://yandex.ru")!
    }
    let client = Client(
        serverURL: safeURL,
        transport: URLSessionTransport(),
        middlewares: [AuthenticationMiddleware(apikey: "e0940f60-7b86-40f1-ba94-6a70f7d38166")]
    )
    let service = AllStationsService(client: client)
    
    return NavigationStack {
        SelectCityView(selectedStation: .constant(""), selectedStationCode: .constant(""),stationsService: service)
    }
    
}
