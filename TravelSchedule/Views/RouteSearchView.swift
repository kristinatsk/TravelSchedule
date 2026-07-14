import SwiftUI
import OpenAPIURLSession

struct RouteSearchView: View {
    @State private var viewModel: RouteSearchViewModel
    
    init(stationsService: AllStationsServiceProtocol, carrierInfoService: CarrierInfoServiceProtocol, scheduleBetweenStationsService: ScheduleBetweenStationsServiceProtocol) {
        self._viewModel = State(
            initialValue:
                RouteSearchViewModel(carrierInfoService: carrierInfoService,
                                     scheduleBetweenStationsService: scheduleBetweenStationsService,
                                     stationsService: stationsService
                                    ))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.stories) { story in
                            ZStack(alignment: .bottomLeading) {
                                Image(story.backgroundImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 92, height: 140)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                
                                    .opacity(story.hasSeen ? 0.5 : 1.0)
                                    .overlay {
                                        if !story.hasSeen {
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.blueUniversal, lineWidth: 4)
                                        }
                                    }
                                VStack {
                                    Text(story.title)
                                        .font(.system(size: 12, weight: .regular))
                                        .lineLimit(3)
                                        .foregroundColor(.white)
                                        .frame(width: 76, height: 45)
                                        .padding(.leading, 4)
                                        .padding(.bottom, 8)
                                }
                                .onTapGesture {
                                    viewModel.selectedStory = story
                                    let index = viewModel.stories.firstIndex(where: { $0.id == story.id}) ?? 0
                                    viewModel.stories[index].hasSeen = true
                                }
                                
                            }
                        }
                    }
                    .padding()
                }
                HStack {
                    VStack(alignment: .leading, spacing: 28) {
                        NavigationLink {
                            SelectCityView(service: viewModel.stationsService, selectedStation: $viewModel.departureCity,  selectedStationCode: $viewModel.departureStationCode)
                        } label: {
                            if viewModel.departureCity.isEmpty {
                                Text("Откуда")
                            } else {
                                Text(viewModel.departureCity)
                                    .foregroundColor(.black)
                            }
                        }
                        
                        NavigationLink {
                            SelectCityView(service: viewModel.stationsService, selectedStation: $viewModel.arrivalCity, selectedStationCode: $viewModel.arrivalStationCode)
                        } label: {
                            if viewModel.arrivalCity.isEmpty {
                                Text("Куда")
                            } else {
                                Text(viewModel.arrivalCity)
                                    .foregroundColor(.black)
                            }
                        }
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.grayUniversal)
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .buttonStyle(.plain)
                    
                    Button {
                        viewModel.reverseRoute()
                    } label: {
                        Image(.сhange)
                            .foregroundColor(.white)
                    }
                    
                    
                }
                .padding()
                .background(.blueUniversal)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding()
                
                if !viewModel.departureCity.isEmpty && !viewModel.arrivalCity.isEmpty {
                    NavigationLink {
                        CarrierListView(
                            selectedDepartureStation: viewModel.departureCity,
                            selectedArrivalStation: viewModel.arrivalCity,
                            departureCode: viewModel.departureStationCode,
                            arrivalCode: viewModel.arrivalStationCode,
                            scheduleBetweenStationsService: viewModel.scheduleBetweenStationsService
                        )
                    } label: {
                        Text("Найти")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 150)
                            .padding()
                            .background(.blueUniversal)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
                Spacer()
                Divider()
                
            }
            .fullScreenCover(item: $viewModel.selectedStory) { story in
                let index = Story.mockData.firstIndex(where: { $0.id == story.id}) ?? 0
                StoriesView(stories: $viewModel.stories, initialIndex: index)
                
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
    let carrierInfoService = CarrierInfoService(client: client)
    let scheduleBetweenStationsService = ScheduleBetweenStationsService(client: client)
    
    
     RouteSearchView(
        stationsService: service, carrierInfoService: carrierInfoService,
        scheduleBetweenStationsService: scheduleBetweenStationsService
    )
    
}
