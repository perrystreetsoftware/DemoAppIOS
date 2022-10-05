//
//  File.swift
//  
//
//  Created by Matheus on 05/10/22.
//

import Foundation
import SwiftUI

enum UserGridCellType {
    case grid
    case carousel
}

struct UserGridCell: View {
    let stackId: String
    let user: ProfileGridCellUIModel
    let userGridCellType: UserGridCellType
//    let onProfileTapped: ((PSSUser) -> Void)?
//    let onProfileDisappeared: ((String, PSSUser) -> Void)?
//    let getFullUser: ((Int) -> PSSUser)

    @State var labelFrame: CGRect = .zero
    
    private var isOnlineAcessibilityValue: String {
        return user.isOnline == true ? "" : ""
    }
    
    init(stackId: String,
         user: ProfileGridCellUIModel,
         userGridCellType: UserGridCellType
//         onProfileTapped: ((TransitionAnimationUser) -> Void)?,
//         onProfileDisappeared: ((String, TransitionAnimationUser) -> Void)?,
//         getFullUser: @escaping ((Int) -> PSSUser)
    ) {
        
        self.stackId = stackId
        self.user = user
        self.userGridCellType = userGridCellType
//        self.onProfileTapped = onProfileTapped
//        self.onProfileDisappeared = onProfileDisappeared
//        self.getFullUser = getFullUser
    }
    
//    @Environment(\.pss_v7stylesheet) private var stylesheet
    
    var body: some View {
        GeometryReader { containerGeometry in
            ZStack(alignment: .bottom) {
//                if user.hasAnyUnreadMessages {
//                    ZStack {
//                        let unreadIndicatorSizeAndPadding = userGridCellType == .carousel ? 12.0 : 8.0
//                        Circle()
//                            .frame(width: unreadIndicatorSizeAndPadding, height: unreadIndicatorSizeAndPadding)
//                            .foregroundColor(stylesheet.color(.accent))
//                            .padding(unreadIndicatorSizeAndPadding)
//                    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
//                }
                
                HStack(spacing: 4) {
                    
                    let statusAccentColor: Color = .red
                    
                    
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundColor(statusAccentColor)
                    
                    Text(user.name ?? "")
                        .lineLimit(1)
                        .foregroundColor(.black)
                        .overlay(GeometryReader { textGeometry in
                            Text("").onAppear {
                                self.labelFrame = textGeometry.frame(in: .global)
                            }
                        })
                }
                .frame(maxWidth: .infinity, alignment: .bottomLeading)
                .padding(.leading, 8)
                .padding(.trailing, 8)
                .padding(.bottom, 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .contentShape(Rectangle())
            .accessibilityLabel(Text(user.name ?? ""))
            .accessibilityValue(isOnlineAcessibilityValue)
        }
        .background(
            ZStack {
                AsyncImage(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Alexander_Mathis_at_Harvard_2020.jpg/800px-Alexander_Mathis_at_Harvard_2020.jpg")!,
                           content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: 300, maxHeight: 100)
                }, placeholder: {
                    ProgressView()
                })
            }
                .accessibilityHidden(true)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(.red, lineWidth: user.hasAnyUnreadMessages ? 4 : 0)
        )
        .cornerRadius(4)
    }
}
