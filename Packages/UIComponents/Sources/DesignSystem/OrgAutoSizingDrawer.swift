import SwiftUI

public struct OrgAutoSizingDrawer<Header: View, Content: View, Footer: View>: View {
    private static var detentAnimation: Animation {
        .spring(response: 0.34, dampingFraction: 0.9, blendDuration: 0.12)
    }

    private static var detentCleanupDelay: TimeInterval {
        0.42
    }

    @Environment(\.theme) private var theme
    @State private var measuredHeight: CGFloat = .zero
    @State private var activeDetents: Set<PresentationDetent> = [.medium]
    @State private var selectedDetent: PresentationDetent = .medium
    @State private var detentTransitionToken: Int = 0

    private let header: () -> Header
    private let content: () -> Content
    private let footer: () -> Footer

    public init(
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.header = header
        self.content = content
        self.footer = footer
    }

    @ViewBuilder
    private var drawerContent: some View {
        VStack(spacing: theme.spacing.moduleRegular) {
            VStack(spacing: theme.spacing.componentExpanded) {
                header()
                content().frame(maxWidth: .infinity)
            }

            footer()
        }
        .padding(.horizontal, theme.padding.screenHorizontal)
        .padding(.top, theme.padding.screenBottomRegular)
    }

    private var measurementContent: some View {
        drawerContent
            .fixedSize(horizontal: false, vertical: true)
            .hidden()
            .onGeometryChange(for: CGSize.self) {
                $0.size
            } action: { newValue in
                updateSheetHeight(to: max(1, newValue.height.rounded()))
            }
    }

    private func updateSheetHeight(to nextHeight: CGFloat) {
        // Ignore sub-point geometry noise to prevent animation jitter.
        guard abs(nextHeight - measuredHeight) > 0.5 else {
            return
        }

        if measuredHeight == .zero {
            measuredHeight = nextHeight
            let initialDetent = PresentationDetent.height(nextHeight)
            activeDetents = [initialDetent]
            selectedDetent = initialDetent
            return
        }

        measuredHeight = nextHeight
        let newDetent = PresentationDetent.height(nextHeight)

        guard selectedDetent != newDetent else {
            return
        }

        let previousDetent = selectedDetent
        activeDetents = [previousDetent, newDetent]

        withAnimation(Self.detentAnimation) {
            selectedDetent = newDetent
        }

        detentTransitionToken += 1
        let token = detentTransitionToken
        DispatchQueue.main.asyncAfter(deadline: .now() + Self.detentCleanupDelay) {
            guard token == detentTransitionToken else {
                return
            }

            activeDetents = [selectedDetent]
        }
    }

    public var body: some View {
        VStack(spacing: 0) {
            drawerContent
            // makes drawer content top-aligned within the sheet, which makes animations look correct
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(alignment: .top) {
            measurementContent
        }
        .presentationDetents(activeDetents, selection: $selectedDetent)
        .presentationDragIndicator(.hidden)
    }
}
