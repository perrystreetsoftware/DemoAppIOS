import SwiftUI

struct City: Identifiable, Equatable {
    let id = UUID()
    let name: String
    var isSelected: Bool
}

struct CityList: View {
    @StateObject var viewModel = CityViewModel()
        
    var body: some View {
        VStack(spacing: 16) {
            Text("Select two favorite cities")
            
            if viewModel.cityViewState.isEmpty == false {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(viewModel.cityViewState) { city in
                            Text(city.name)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(city.isSelected ? Color.green : Color.gray.opacity(0.3))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .onTapGesture {
                                    viewModel.didTapCity(city)
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

public class CityViewModel: ObservableObject {
    @Published var cityViewState: [City] = []
    
    public init() {
        getCities()
    }
    
    func didTapCity(_ city: City) {
    
        var newState: [City] = []
        
        cityViewState.forEach {
            var currentCity = $0
            if currentCity == city {
                currentCity.isSelected = !currentCity.isSelected
            }
            newState.append(currentCity)
        }
        
        cityViewState = newState
    }
    
    private func getCities() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.cityViewState = .init(
                [
                    City(name: "Nova York", isSelected: false),
                    City(name: "Paris", isSelected: false),
                    City(name: "Londres", isSelected: false),
                    City(name: "Tóquio", isSelected: false),
                    City(name: "São Paulo", isSelected: false),
                    City(name: "Moscou", isSelected: false),
                    City(name: "Dubai", isSelected: false),
                    City(name: "Pequim", isSelected: false),
                    City(name: "Sydney", isSelected: false),
                    City(name: "Toronto", isSelected: false)
                ]
            )
        }
    }
}
