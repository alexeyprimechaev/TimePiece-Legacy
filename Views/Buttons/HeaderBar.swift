//
//  HeaderBar.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 3/10/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct HeaderBar<Leading: View, Trailing: View>: View {
    
    @EnvironmentObject var settings: Settings

    
        
    var leadingItem: Leading
    var trailingItems: Trailing
    
    var hasTrailingContent: Bool
    var showingMenu: Bool
    
    private init(@ViewBuilder leadingItem: @escaping () -> Leading, @ViewBuilder trailingItems: @escaping () -> Trailing, hasTrailingContent: Bool = true, showingMenu: Bool = true) {
        self.leadingItem = leadingItem()
        self.trailingItems = trailingItems()
        self.hasTrailingContent = hasTrailingContent
        self.showingMenu = showingMenu
    }
    
//    init(@ViewBuilder leadingItem: @escaping () -> Leading) {
//        self.leadingItem = leadingItem()
//        self.trailingItems = { nil }()
//        self.hasTrailingContent = false
//    }
    
    
    var body: some View {
        HStack {
            leadingItem
            Spacer()
            if hasTrailingContent {
                if showingMenu {
                    Menu {
                        trailingItems
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(.primary).padding(.horizontal, 14).font(.title2)
                    }
                } else {
                    trailingItems
                }
            }
            
            
        }.padding(.horizontal, 21)
        .frame(height: 52)
        
    }
}


extension HeaderBar where Trailing == EmptyView {
    init(@ViewBuilder leadingItem: @escaping () -> Leading) {
        self.init(leadingItem: leadingItem, trailingItems: { EmptyView()}, hasTrailingContent: false)
    }
}

extension HeaderBar {
    init(@ViewBuilder leadingItem: @escaping () -> Leading, @ViewBuilder trailingItems: @escaping () -> Trailing) {
        self.init(leadingItem: leadingItem, trailingItems: trailingItems, hasTrailingContent: true)
    }
    init(showingMenu: Bool, @ViewBuilder leadingItem: @escaping () -> Leading, @ViewBuilder trailingItems: @escaping () -> Trailing) {
        self.init(leadingItem: leadingItem, trailingItems: trailingItems, hasTrailingContent: true, showingMenu: showingMenu)
    }
}
