import SwiftUI

public class SampleMainViewModel: ObservableObject {
    @Published var cityViewState: [City] = []
    @Published var foodViewState: [Food] = []
    
    public init() {
        getCities()
        getFoods()
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
    
    func didTapFood(_ food: Food) {
        
        var newState: [Food] = []
        
        foodViewState.forEach {
            var currentFood = $0
            if currentFood == food {
                currentFood.isSelected = !currentFood.isSelected
            }
            newState.append(currentFood)
        }
        
        foodViewState = newState
    }
    
    private func getFoods() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.foodViewState = .init(
                [
                    Food(name: "Pizza", isSelected: false),
                    Food(name: "Hamburger", isSelected: false),
                    Food(name: "Sushi", isSelected: false),
                    Food(name: "Tacos", isSelected: false),
                    Food(name: "Pasta", isSelected: false),
                    Food(name: "Curry", isSelected: false),
                    Food(name: "Steak", isSelected: false),
                    Food(name: "Dim Sum", isSelected: false),
                    Food(name: "Paella", isSelected: false),
                    Food(name: "Falafel", isSelected: false)
                ]
            )
        }
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
