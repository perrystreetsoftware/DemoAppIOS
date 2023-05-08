import SwiftUI

public struct SampleMainView: View {
    @StateObject var viewModel = SampleMainViewModel()
    
    public init() {}
    
    public var body: some View {

        VStack {
            Text("Tell me more about you")
                .padding(.top, 8)
            
            CityList()
                .padding(.top, 16)
            
            FoodList()
                .padding(.top, 32)
            
            Spacer(minLength: 8)
        }
    }
}
