//
//  RegularButton.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 2/23/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct RegularButton: View {
    
    @State var title = LocalizedStringKey("")
    @State var icon = "arrow.clockwise"
    
    var action: () -> Void
    
    var body: some View {
        
        Button {
            self.action()
        } label: {
            Label {
                Text(title).fontSize(.smallTitle)
            } icon: {
                Image(systemName: icon).font(.headline)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 7)
        }
        .foregroundColor(.primary)
        .buttonStyle(RegularButtonStyle())
    }
}

