//
//  PauseButton.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/13/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct PauseButton: View {
    
//MARK: - Properties
    
    
    
    //MARK: Dynamic Properties
    @State var color: Color
    @Binding var isPaused: Bool
    
    
    //MARK: Static Properties
    var offTitle = LocalizedStringKey("")
    var onTitle = LocalizedStringKey("")
    
    var offIcon = String()
    var onIcon = String()
    
    var onTap: () -> ()
    var offTap: () -> ()
    
//MARK: - View
    var body: some View {
        
        Button {
            if self.isPaused {
                self.onTap()
            } else {
                self.offTap()
            }
        } label: {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .foregroundColor(Color("button.gray"))
                Label(isPaused ? offTitle : onTitle, systemImage: isPaused ? offIcon : onIcon)
                .foregroundColor(color)
                .smallTitle()
            }.frame(height: 52)
        }
        
    }
}

