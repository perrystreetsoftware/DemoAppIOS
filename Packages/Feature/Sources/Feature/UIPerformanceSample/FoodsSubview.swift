import SwiftUI

struct Food: Identifiable, Equatable {
    let id = UUID()
    let name: String
    var isSelected: Bool
}

struct FoodList: View {
    @StateObject var viewModel = FoodsViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Select two favorite foods")
            
            if viewModel.foodViewState.isEmpty == false {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.foodViewState) { food in
                            VStack {
                                Text(food.name)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(food.isSelected ? Color.green : Color.gray.opacity(0.3))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        viewModel.didTapFood(food)
                                    }
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 5)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            } else {
                Text("Im loading the foods")
            }
        }
    }
}

public class FoodsViewModel: ObservableObject {
    @Published var foodViewState: [Food] = []
    
    public init() {
        getFoods()
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
}
