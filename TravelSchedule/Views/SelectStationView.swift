import SwiftUI
import OpenAPIURLSession

struct SelectStationView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @Binding var selectedStation: String
    @Binding var selectedStationCode: String
    
    let stations: [Components.Schemas.Station]
    var searchResults: [Components.Schemas.Station] {
        if searchText.isEmpty {
            stations
        } else {
            stations.filter { station in (station.title ?? "").localizedCaseInsensitiveContains(searchText)}
        }
    }
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
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
                                Image(systemName: "chevron.right")
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
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

#Preview {
    SelectStationView(selectedStation: .constant(""), selectedStationCode: .constant(""), stations: [])
}
