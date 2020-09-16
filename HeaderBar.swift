//
//  HeaderBar.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 3/10/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct HeaderBar: View {
    
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
                    Label(leadingTitle, systemImage: leadingIcon)
                    .smallTitle()
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
                    Label(trailingTitle, systemImage: trailingIcon)
                    .smallTitle()
                    .padding(.horizontal, 28)
                    .foregroundColor(trailingIsDestructive ? .red : .primary)
                }
            }
            
            
        }
        .frame(height: 52)
        
    }
}
