import SwiftUI

public struct UserContainerView: View {
    @StateObject var viewModel = RedrawViewModel2()

    public init() {}

    public var body: some View {
        let _ = Self._printChanges()

        List {
            ForEach(0..<100) { index in
                UserCell(index: index) {
                    viewModel.onUserAppear(index: index)
                }
            }
        }
        .navigationBarTitle(viewModel.isReachingLastUser ? "Reaching last user" : "Far from last user")
    }
}

struct UserCell: View {
    let index: Int
    let onAppear: () -> Void

    var body: some View {
        Text("User \(index)")
            .padding(5)
            .onAppear(perform: onAppear)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        UserContainerView()
    }
}
