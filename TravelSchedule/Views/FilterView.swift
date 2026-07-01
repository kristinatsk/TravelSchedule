import SwiftUI

enum DepartureTime: String, CaseIterable {
    case morning = "Утро 06:00 - 12:00"
    case afternoon = "День 12:00 - 18:00"
    case evening = "Вечер 18:00 - 00:00"
    case night = "Ночь 00:00 - 06:00"
}



struct FilterView: View {
    @Binding var selectedTimes: Set<DepartureTime>
    @Binding var showTransfers: Bool
    @Environment(\.dismiss) var dismiss

    var body: some View {
        
        VStack(alignment: .leading, spacing: 32) {
            
            
            VStack(alignment: .leading, spacing: 24) {
                Text("Время отправления")
                    .font(.system(size: 24, weight: .bold))
                
                ForEach(DepartureTime.allCases, id: \.self) { time in
                    Button {
                        if selectedTimes.contains(time) {
                            selectedTimes.remove(time)
                        } else {
                            selectedTimes.insert(time)
                        }
                    } label: {
                        HStack {
                            Text(time.rawValue)
                            Spacer()
                            Image(systemName: selectedTimes.contains(time) ? "checkmark.square.fill" : "square")
                        }
                        .foregroundColor(.primary)
                    }
                }
            }
            
            
            VStack(alignment: .leading, spacing: 24) {
                Text("Показывать варианты с пересадками")
                    .font(.system(size: 24, weight: .bold))
                
                Button {
                    showTransfers = true
                } label: {
                    HStack {
                        Text("Да")
                        Spacer()
                        Image(systemName: showTransfers ? "record.circle" : "circle")
                    }
                    .foregroundColor(.primary)
                }
                
                Button {
                    showTransfers = false
                } label: {
                    HStack {
                        Text("Нет")
                        Spacer()
                        Image(systemName: showTransfers ? "circle" : "record.circle")
                    }
                    .foregroundColor(.primary)
                }
            }
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("Применить")
                    .foregroundColor(.white)
                    .font(.system(size: 17, weight: .bold))
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .background(.blueUniversal)
                    .cornerRadius(16)
            }
        }
        .padding(16)
        .navigationBarTitleDisplayMode(.inline)
    }
}
#Preview {
    FilterView(selectedTimes: .constant([]), showTransfers: .constant(true))
}
