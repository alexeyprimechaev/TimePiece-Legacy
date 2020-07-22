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
                    HStack(alignment: .center) {
                        Image(systemName: leadingIcon)
                            .smallTitle()
                        Text(leadingTitle)
                            .smallTitle()
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
                    HStack(alignment: .center) {
                        Image(systemName: trailingIcon)
                            .smallTitle()
                            .padding(.bottom, trailingIcon == "arrow.clockwise" ? 2 : 0)
                        Text(trailingTitle)
                            .smallTitle()
                    }
                    .padding(.horizontal, 28)
                    .foregroundColor(trailingIsDestructive ? .red : .primary)
                }
            }
            
            
        }
        .frame(height: 52)
        
    }
}
