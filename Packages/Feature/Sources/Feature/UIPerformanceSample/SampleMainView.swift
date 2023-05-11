import SwiftUI

//public struct SampleMainView: View {
//    @StateObject var viewModel = SampleMainViewModel()
//
//    public init() {}
//
//    public var body: some View {
//
//        VStack {
//            Text("Tell me more about you")
//                .padding(.top, 8)
//
//            CityList(state: viewModel.cityViewState, didTapCity: viewModel.didTapCity(_:))
//                .padding(.top, 16)
//
//            FoodList(state: viewModel.foodViewState, didTapFood: viewModel.didTapFood(_:))
//                .padding(.top, 32)
//
//            Spacer(minLength: 8)
//        }
//    }
//}

public struct SampleMainViewAdapter: View {
    @StateObject var viewModel = SampleMainViewModel()
    
    public init() {}
    
    public var body: some View {
        SampleMainView(
            cityListState: viewModel.cityViewState,
            foodListState: viewModel.foodViewState,
            didTapCity: {
                viewModel.didTapCity($0)
            },
            didTapFood: {
                viewModel.didTapFood($0)
            }
        )
    }
}

public struct SampleMainView: View {
    var cityListState: [City]
    var foodListState: [Food]
    var didTapCity: ((City) -> ())
    var didTapFood: ((Food) -> ())

    init(cityListState: [City], foodListState: [Food], didTapCity: @escaping (City) -> Void, didTapFood: @escaping (Food) -> Void) {
        self.cityListState = cityListState
        self.foodListState = foodListState
        self.didTapCity = didTapCity
        self.didTapFood = didTapFood
    }
    
    public var body: some View {

        VStack {
            Text("Tell me more about you")
                .padding(.top, 8)

            CityList(state: cityListState, didTapCity: didTapCity)
                .padding(.top, 16)

            FoodList(state: foodListState, didTapFood: didTapFood)
                .padding(.top, 32)

            Spacer(minLength: 8)
        }
    }
}
