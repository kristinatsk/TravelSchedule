import SwiftUI
import OpenAPIURLSession

struct SelectCityView: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel: CitiesViewModel
    @Binding var selectedStation: String
    @Binding var selectedStationCode: String
    
    init(service: AllStationsServiceProtocol, selectedStation: Binding<String>, selectedStationCode: Binding<String>) {
        self._viewModel = State(initialValue: CitiesViewModel(stationsService: service))
        self._selectedStation = selectedStation
        self._selectedStationCode = selectedStationCode
    }
    
    var body: some View {
        Group {
            switch viewModel.currentViewState {
            case .loading:
                ProgressView()
            case .success:
                VStack {
                    HStack {
                        Image(systemName: Constants.Icons.magnifyingGlass)
                        TextField("Введите запрос", text: $viewModel.searchText)
                        if !viewModel.searchText.isEmpty {
                            Button {
                                viewModel.searchText = ""
                            } label: {
                                Image(systemName: Constants.Icons.xmark)
                                    .foregroundColor(.grayUniversal)
                            }
                        }
                    }
                    .padding(8)
                    .background(.searchBarBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
                    if !viewModel.searchText.isEmpty && viewModel.searchResults.isEmpty {
                        Spacer()
                        
                        Text("Город не найден")
                            .font(.system(size: 24, weight: .bold))
                        Spacer()
                    } else {
                        List {
                            ForEach(viewModel.searchResults, id: \.self) { city in
                                ZStack {
                                    HStack {
                                        Text(city.title ?? "")
                                            .frame(height: 60)
                                        Spacer()
                                        Image(systemName: Constants.Icons.chevronRight)
                                            .foregroundColor(.primary)
                                    }
                                    NavigationLink {
                                        SelectStationView(service: viewModel.stationsService, selectedStation: $selectedStation, selectedStationCode: $selectedStationCode)
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
                    Image(systemName: Constants.Icons.chevronLeft)
                        .foregroundColor(.primary)
                }
            }
        }
        .task {
            viewModel.fetchCities()
        }
        
        .onChange(of: selectedStation) { oldValue, newValue in
            dismiss()
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
        SelectCityView(service: service, selectedStation: .constant(""), selectedStationCode: .constant(""))
    }
    
}
