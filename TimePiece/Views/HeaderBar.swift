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
    var leadingTitle = String()
    var leadingIcon = String()
    var leadingIsDestructive = false
    
    var trailingAction: () -> ()
    var trailingTitle = String()
    var trailingIcon = String()
    var trailingIsDestructive = false
    
    var body: some View {
        HStack() {
            if leadingTitle != String() {
                Button(action: {
                    self.leadingAction()
                }) {
                    HStack(alignment: .center) {
                        Image(systemName: leadingIcon)
                            .font(.system(size: 11.0, weight: .heavy))
                            .smallTitleStyle()
                        Text(leadingTitle)
                            .smallTitleStyle()
                    }
                    .padding(.horizontal, 28)
                    .foregroundColor(leadingIsDestructive ? .red : .primary)
                    Spacer()
                }
            }
            
            if trailingTitle != String() {
                Button(action: {
                    self.trailingAction()
                }) {
                    Spacer()
                    HStack(alignment: .center) {
                        Image(systemName: trailingIcon)
                            .font(.system(size: 11.0, weight: .heavy))
                            .smallTitleStyle()
                            .padding(.bottom, trailingIcon == "arrow.clockwise" ? 2 : 0)
                        Text(trailingTitle)
                            .smallTitleStyle()
                    }
                    .padding(.horizontal, 28)
                    .foregroundColor(trailingIsDestructive ? .red : .primary)
                }
            }
            
            
        }
        .frame(height: 52)
        
    }
}
