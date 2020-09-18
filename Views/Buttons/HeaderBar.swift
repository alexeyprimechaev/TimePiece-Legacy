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
    
    var leadingAction: () -> ()
    var leadingTitle = LocalizedStringKey("")
    var leadingIcon = String()
    var leadingIsDestructive = false
    
    var trailingAction: () -> ()
    var trailingTitle = LocalizedStringKey("")
    var trailingIcon = String()
    var trailingIsDestructive = false
    
    var body: some View {
        HStack() {
            if leadingTitle != LocalizedStringKey("") {
                Button(action: {
                    lightHaptic()
                    self.leadingAction()
                }) {
                    Label {
                        Text(leadingTitle).fontSize(.smallTitle)
                    } icon: {
                        Image(systemName: leadingIcon).font(.headline).saturation(settings.isMonochrome ? 0 : 1)
                    }
                    .padding(.horizontal, 28)
                    .foregroundColor(leadingIsDestructive ? .red : .primary)
                    Spacer()
                }
            }
            
            if trailingTitle != LocalizedStringKey("") {
                Button(action: {
                    self.trailingAction()
                }) {
                    Spacer()
                    Label {
                        Text(trailingTitle).fontSize(.smallTitle)
                    } icon: {
                        Image(systemName: trailingIcon).font(.headline).saturation(settings.isMonochrome ? 0 : 1)
                    }
                    .padding(.horizontal, 28)
                    .foregroundColor(trailingIsDestructive ? .red : .primary)
                }
            }
            
            
        }
        .frame(height: 52)
        
    }
}
