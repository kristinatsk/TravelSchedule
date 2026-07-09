import SwiftUI
import OpenAPIURLSession


struct CarrierDetailView: View {
    let carrier: Components.Schemas.Carrier
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                
                AsyncImage(url: URL(string: carrier.logo ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Color.grayUniversal
                }
                .frame(height: 104)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 24) {
                
                Text(carrier.title ?? "")
                    .font(.system(size: 24, weight: .bold))
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("E-mail")
                        .font(.system(size: 17, weight: .regular))
                    Text(carrier.email ?? "")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.blueUniversal)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Телефон")
                        .font(.system(size: 17, weight: .regular))
                    Text(carrier.phone ?? "")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.blueUniversal)
                }
            }
            Spacer()
        }
        .padding(16)
        .navigationTitle("Информация о перевозчике")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

#Preview {
    CarrierDetailView(
        carrier: Components.Schemas.Carrier(
            code: 112,
            title: "ОАО «РЖД»",
            phone: "+7 (904) 329-27-71",
            logo: "https://yastat.net/s3/rasp/media/data/company/logo/rzhd.jpg",
            email: "i.lozgkina@yandex.ru"
        )
    )
}
