import SwiftUI
import OpenAPIURLSession

struct SelectStationView: View {
    @Environment(\.dismiss) var dismiss
    @State var searchText = ""
    @Binding var selectedStation: String
    
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
            .padding()
            .background(.lightGray)
            .cornerRadius(10)
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
                            dismiss()
                        } label: {
                            HStack {
                                Text(station.title ?? "")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            
                        }
                        .foregroundColor(.black)
                    }
                }
                
                .listStyle(.plain)
            }
        }
        .navigationTitle("Выбор станции")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SelectStationView(selectedStation: .constant(""), stations: [])
}
