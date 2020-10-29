//
//  HeaderBar.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 3/10/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct HeaderBar: View {
    
    @EnvironmentObject var settings: Settings
    
    var leadingAction: () -> Void
    var leadingTitle = LocalizedStringKey("")
    var leadingIcon = String()
    var leadingIsDestructive = false
    
    var trailingAction: () -> Void
    var trailingTitle = LocalizedStringKey("")
    var trailingIcon = String()
    var trailingIsDestructive = false
    
    var body: some View {
        HStack {
            if leadingTitle != LocalizedStringKey("") {
                Button {
                    leadingAction()
                } label: {
                    Label {
                        Text(leadingTitle).fontSize(.smallTitle)
                    } icon: {
                        Image(systemName: leadingIcon).font(.headline).saturation(settings.isMonochrome ? 0 : 1)
                    }
                    .padding(.horizontal, 14)
                    .foregroundColor(leadingIsDestructive ? .red : .primary)
                }
                .buttonStyle(RegularButtonStyle())
            }
            Spacer()
            if trailingTitle != LocalizedStringKey("") {
                Button {
                    trailingAction()
                } label: {
                    Label {
                        Text(trailingTitle).fontSize(.smallTitle)
                    } icon: {
                        Image(systemName: trailingIcon).font(.headline).saturation(settings.isMonochrome ? 0 : 1)
                    }
                    .padding(.horizontal, 14)
                    .foregroundColor(trailingIsDestructive ? .red : .primary)
                }
                .buttonStyle(RegularButtonStyle())
            }
            
            
        }.padding(.horizontal, 14)
        .frame(height: 52)
        
    }
}
