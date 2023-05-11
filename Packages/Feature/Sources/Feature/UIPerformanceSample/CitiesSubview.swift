import SwiftUI

struct City: Identifiable, Equatable {
    let id = UUID()
    let name: String
    var isSelected: Bool
}

struct CityList: View {
    var state: [City]
    
    var didTapCity: ((City) -> ())
    
    init(state: [City], didTapCity: @escaping (City) -> Void) {
        self.state = state
        self.didTapCity = didTapCity
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Select two favorite cities")
            
            if state.isEmpty == false {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(state) { city in
                            Text(city.name)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(city.isSelected ? Color.green : Color.gray.opacity(0.3))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .onTapGesture {
                                    didTapCity(city)
                                }
                        }
                    }
                    .padding(.horizontal, 20)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                }
            } else {
                Text("Loading the cities")
            }
        }
    }
}
