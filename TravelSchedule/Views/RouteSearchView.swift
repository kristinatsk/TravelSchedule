import SwiftUI
import OpenAPIURLSession

struct RouteSearchView: View {
    let carrierInfoService: CarrierInfoService
    let scheduleBetweenStationsService: ScheduleBetweenStationsService
    
    @State private var departureCity = ""
    @State private var arrivalCity = ""
    @State private var departureStationCode = ""
    @State private var arrivalStationCode = ""
    @State private var selectedStory: Story?
    @State private var stories = Story.mockData
    
    let stationsService: AllStationsService
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(stories) { story in
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
                                    selectedStory = story
                                    let index = stories.firstIndex(where: { $0.id == story.id}) ?? 0
                                    stories[index].hasSeen = true
                                }
                                
                            }
                        }
                    }
                    .padding()
                }
                HStack {
                    VStack(alignment: .leading, spacing: 28) {
                        NavigationLink {
                            SelectCityView(selectedStation: $departureCity,  selectedStationCode: $departureStationCode, stationsService: stationsService)
                        } label: {
                            if departureCity.isEmpty {
                                Text("Откуда")
                            } else {
                                Text(departureCity)
                                    .foregroundColor(.black)
                            }
                        }
                        
                        NavigationLink {
                            SelectCityView(selectedStation: $arrivalCity, selectedStationCode: $arrivalStationCode, stationsService: stationsService)
                        } label: {
                            if arrivalCity.isEmpty {
                                Text("Куда")
                            } else {
                                Text(arrivalCity)
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
                        (departureCity, arrivalCity) = (arrivalCity, departureCity)
                    } label: {
                        Image(.сhange)
                            .foregroundColor(.white)
                    }
                    
                    
                }
                .padding()
                .background(.blueUniversal)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding()
                
                if !departureCity.isEmpty && !arrivalCity.isEmpty {
                    NavigationLink {
                        CarrierListView(
                            selectedDepartureStation: departureCity,
                            selectedArrivalStation: arrivalCity,
                            departureCode: departureStationCode,
                            arrivalCode: arrivalStationCode,
                            scheduleBetweenStationsService: scheduleBetweenStationsService
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
                
            }
            .fullScreenCover(item: $selectedStory) { story in
                let index = Story.mockData.firstIndex(where: { $0.id == story.id}) ?? 0
                StoriesView(stories: Story.mockData, initialIndex: index)
                
            }
            
            
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
    let carrierInfoService = CarrierInfoService(client: client)
    let scheduleBetweenStationsService = ScheduleBetweenStationsService(client: client)
    
    
    return RouteSearchView(
        carrierInfoService: carrierInfoService,
        scheduleBetweenStationsService: scheduleBetweenStationsService,
        stationsService: service
    )
    
}
