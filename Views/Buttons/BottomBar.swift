//
//  TabBar.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 5/30/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct BottomBar<Content:View>: View {
    
    
    @EnvironmentObject var settings: Settings
    
    var content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 0) {
                Spacer().frame(width: 14)
                
                content
                
                Spacer()
            }
        }
        
    }
}

struct BottomBarItem: View {
    
    @State var title = LocalizedStringKey("")
    
    @State var icon = "plus"
    
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Label {
                Text(title).fontSize(.smallTitle)
            } icon: {
                Image(systemName: icon).font(.headline)
            }
            .lineLimit(1)
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 12, style: .continuous).foregroundColor(Color(.systemBackground)))
            
        }
        
        .buttonStyle(RegularButtonStyle())
        
        
    }
}
