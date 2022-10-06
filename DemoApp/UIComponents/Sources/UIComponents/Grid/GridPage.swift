//
//  GridPage.swift
//  
//
//  Created by Matheus on 05/10/22.
//

import Foundation
import SwiftUI


struct ProfileGrid: View {
    public static var AspectRatio: CGFloat = 0.75

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.redactionReasons) private var reasons

    private let stacks: [ProfileGridStackUIModel]

    public init(stacks: [ProfileGridStackUIModel]
    ) {
        self.stacks = stacks
    }
    
    var body: some View {
        let columnCount: Int = 3
        
        // we're using this grid component instead of LazyVGrid because there's
        // a bug when you put multiple LazyVGrids inside a list, they'll all call
        // the cell onAppear all at the same time
        ScrollView {
            LazyVStack {
                ForEach(stacks, id: \.self) { stack in
                    Grid(stack: stack, columns: columnCount)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .listStyle(PlainListStyle())
    }
    
    @ViewBuilder private func Grid(stack: ProfileGridStackUIModel, columns: Int) -> some View {
        let chunks = stride(from: 0, to: stack.profiles.count, by: columns).map {
            Array(stack.profiles[$0..<min($0 + columns, stack.profiles.count)])
        }
            
        
        ForEach(chunks, id: \.self) { chunk in
            GridRow(chunk: chunk, stack: stack, columns: columns)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
    }
    
    @ViewBuilder private func GridRow(chunk: [ProfileGridCellUIModel], stack: ProfileGridStackUIModel, columns: Int) -> some View {
        let emptyElements = columns - chunk.count
        HStack(spacing: 8) {
            ForEach(chunk) { user in
                UserGridCell(stackId: "id",
                             user: user,
                             userGridCellType: .grid)
                .aspectRatio(ProfileGrid.AspectRatio, contentMode: .fill)
            }
            
            if emptyElements > 0 {
                ForEach(0..<emptyElements, id: \.self) { _ in
                    Rectangle()
                        .foregroundColor(Color.clear)
                        .contentShape(Rectangle())
                        .frame(maxWidth: .infinity)
                        .aspectRatio(ProfileGrid.AspectRatio, contentMode: .fill)
                }
            }
        }
    }
}

public struct GridPage: View {
//    var state: Binding<CountryDetailsViewModel.State>
//    private var onPageLoaded: (() -> Void)?

    static let MaxUsers: Int = 200

    private var stacks: [ProfileGridStackUIModel]
    public init() {
        let profiles: [ProfileGridCellUIModel] = Array(1..<Self.MaxUsers).map {
            ProfileGridCellUIModel(user: PSSUser.stub(id: $0), index: $0)
        }
        
//        for i in 0...100
        let stacks: [ProfileGridStackUIModel] = [
            ProfileGridStackUIModel(profiles: profiles)
        ]
        
//        self.profiles = profiles
        self.stacks = stacks
    }

    public var body: some View {
        ZStack {
//            ProgressIndicator(isLoading: state.map { $0.isLoading })
//            CountryNotFoundErrorView(viewModelState: state)
//            CountryDetailsContent(countryName: state.map { $0.countryName ?? "" }.wrappedValue,
//                                  detailsText: state.map { $0.countryDetails ?? "" }.wrappedValue)
            ProfileGrid(stacks: stacks)
        }
    }
}

struct GridPage_Previews: PreviewProvider {
    static var previews: some View {
        
        let profiles: [ProfileGridCellUIModel] = Array(1..<GridPage.MaxUsers).map {
            ProfileGridCellUIModel(user: PSSUser.stub(id: $0), index: $0)
        }
        
//        for i in 0...100
        let stacks: [ProfileGridStackUIModel] = [
            ProfileGridStackUIModel(profiles: profiles)
        ]
        
        ProfileGrid(stacks: stacks)
    }
}
