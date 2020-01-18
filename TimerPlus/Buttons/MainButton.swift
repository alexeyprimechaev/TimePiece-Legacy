//
//  MainButton.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/13/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct MainButton: View {
    
    @State var color: Color
    
    @Binding var isPaused: NSNumber?
    
    var offTitle = String()
    var onTitle = String()
    
    var offIcon = String()
    var onIcon = String()
        
    var onTap: () -> ()
    
    var offTap: () -> ()
    
    var body: some View {
        Button(action: {
            if (self.isPaused?.boolValue ?? false) {
                self.onTap()
            } else {
                self.offTap()
            }
        }) {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .foregroundColor(Color("button.gray"))
                HStack() {
                    Image(systemName: isPaused?.boolValue ?? false ? offIcon : onIcon)
                        .padding(.bottom, onIcon == "trash.fill" && !(isPaused?.boolValue ?? false) ? 3 : 0)
                    Text(isPaused?.boolValue ?? false ? offTitle : onTitle)
                    
                }
                .foregroundColor(color)
                .font(.system(size: 17, weight: .semibold))
            }.frame(height: 52)
        }
        
    }
}

