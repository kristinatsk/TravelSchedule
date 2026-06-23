import SwiftUI

struct RouteSearchView: View {
    @State var departureCity = ""
    @State var arrivalCity = ""
    var body: some View {
        NavigationStack {
            VStack {
                Color.clear.frame(height: 188)
                HStack {
                    VStack(alignment: .leading, spacing: 14) {
                        NavigationLink {
                            SelectCityView()
                        } label: {
                            if departureCity.isEmpty {
                                Text("Откуда")
                            } else {
                                Text(departureCity)
                                    .foregroundColor(.black)
                            }
                        }
                        
                        NavigationLink {
                            SelectCityView()
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
                    .cornerRadius(20)
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
                .cornerRadius(20)
                .padding()
                Spacer()
            }
            
        }
    }
}

#Preview {
    RouteSearchView()
}
