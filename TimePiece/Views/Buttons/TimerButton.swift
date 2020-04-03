//
//  TimerButton.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 2/25/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct TimerButton: View {
    
    @State var title = String()
    @State var icon = String()
    @State var sfSymbolIcon = false

    var action: () -> ()
    
    var body: some View {
        
        Button(action: {
            regularHaptic()
            self.action()
        }) {
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .title()
                if sfSymbolIcon {
                    Spacer().frame(height: 15)
                    Image(systemName: icon)
                        .font(.system(size: 21, weight: .bold))
                        .opacity(0.5)
                    Spacer().frame(height: 11)
                } else {
                    Text(icon)
                    .title()
                    .opacity(0.5)
                }
            
            }.padding(7)
            
        }.buttonStyle(RegularButtonStyle())
        
    }
}

