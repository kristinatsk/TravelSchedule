import SwiftUI
import OpenAPIURLSession

struct SelectStationView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @Binding var selectedStation: String
    @Binding var selectedStationCode: String
    
    let stations: [Components.Schemas.Station]
    
    
    init(stations: [Components.Schemas.Station], selectedStation: Binding<String>, selectedStationCode: Binding<String>) {
        self.stations = stations
        self._selectedStation = selectedStation
        self._selectedStationCode = selectedStationCode
    }
    
    var searchResults: [Components.Schemas.Station] {
        if searchText.isEmpty {
            stations
        } else {
            stations.filter { station in (station.title ?? "").localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: Constants.Icons.magnifyingGlass)
                TextField("Введите запрос", text: $searchText)
            }
            .padding(8)
            .background(.searchBarBackground)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
            if !searchText.isEmpty && searchResults.isEmpty {
                Spacer()
                
                Text("Станция не найдена")
                    .font(.system(size: 24, weight: .bold))
                Spacer()
            } else {
                List {
                    ForEach(searchResults, id: \.self) { station in
                        Button {
                            selectedStation = station.title ?? ""
                            selectedStationCode = station.codes?.yandex_code ?? ""
                            dismiss()
                        } label: {
                            HStack {
                                Text(station.title ?? "")
                                    .frame(height: 60)
                                Spacer()
                                Image(systemName: Constants.Icons.chevronRight)
                            }
                            
                        }
                        .foregroundColor(.primary)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    }
                }
                
                .listStyle(.plain)
            }
        }
        .navigationTitle("Выбор станции")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar() {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: Constants.Icons.chevronLeft)
                        .foregroundColor(.primary)
                }
            }
        }

    }
}

#Preview {
    let safeURL = URL(string: "https://yandex.ru")!
    
    let client = Client(
        serverURL: safeURL,
        transport: URLSessionTransport(),
        middlewares: [AuthenticationMiddleware(apikey: "e0940f60-7b86-40f1-ba94-6a70f7d38166")]
    )
    let service = AllStationsService(client: client)
    
    NavigationStack {
        SelectStationView(stations: [], selectedStation: .constant(""), selectedStationCode: .constant(""))
    }
}
