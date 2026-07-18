//
//  CountryAboutDrawer.swift
//  Feature
//
//  Created by Eric Silverberg on 3/29/26.
//

import SwiftUI
import DesignSystem

struct CountryAboutDrawer: View {
    @State private var selectedTab: Int = 0
    @State private var isPulsing: Bool = false

    private var animatedTabSelection: Binding<Int> {
        Binding(
            get: { selectedTab },
            set: { nextValue in
                withAnimation(.spring(response: 0.32, dampingFraction: 0.88, blendDuration: 0.12)) {
                    selectedTab = nextValue
                }
            }
        )
    }

    var body: some View {
        OrgAutoSizingDrawer {
            // Header: Tab Selection
            Picker("View State", selection: animatedTabSelection) {
                Text("Loading").tag(0)
                Text("Loaded").tag(1)
            }
            .pickerStyle(.segmented)
            .padding()
        } content: {
            VStack(alignment: .leading, spacing: 12) {
                if selectedTab == 0 {
                    // Tab 1: Pulsing Skeleton
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 20)
                        .frame(maxWidth: .infinity)
                        .opacity(isPulsing ? 0.5 : 1.0)
                        .transition(.opacity)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                isPulsing = true
                            }
                        }
                } else {
                    // Tab 2: Actual Content
                    Text("This is the actual content of the drawer. It contains five lines of text to demonstrate the dynamic height adjustment of the container. You can swap back to the first tab to see the skeleton state again at any time. This makes debugging UI transitions much smoother.")
                        .lineLimit(5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .transition(.opacity)
                }
            }
            .padding(.horizontal)
        } footer: {
            // Optional: Action buttons or empty
        }
    }
}