import SwiftUI

struct OnPageLoadedModifier: ViewModifier {
    
    @State private var didAppear = false
    
    private let action: (() -> Void)?

    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content.onAppear {
            if didAppear == false {
                didAppear.toggle()
                action?()
            }
        }
    }
}

// MARK: Extension

public extension View {
    /// A modifier that is triggered only the first time that the view appears.
    /// This is useful because you don't need to be managing/storing booleans to know if you can run or not an action on the first load.
    /// Compared to UIKit, is very similiar to viewDidLoad().
    func onPageLoaded(perform action: (() -> Void)? = nil) -> some View {
        modifier(OnPageLoadedModifier(perform: action))
    }
}
