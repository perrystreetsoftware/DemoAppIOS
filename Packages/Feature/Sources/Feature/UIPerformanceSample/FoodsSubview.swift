import SwiftUI

struct Food: Identifiable, Equatable {
    let id = UUID()
    let name: String
    var isSelected: Bool
}

struct FoodList: View {
    struct State {
        var foods: [Food]?
    }
    
    var state: State
    
    var didTapFood: ((Food) -> ())

    var body: some View {
        VStack(spacing: 16) {
            Text("Select two favorite foods")
            
            if let foods = state.foods {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(foods) { food in
                            VStack {
                                Text(food.name)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(food.isSelected ? Color.green : Color.gray.opacity(0.3))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        didTapFood(food)
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
