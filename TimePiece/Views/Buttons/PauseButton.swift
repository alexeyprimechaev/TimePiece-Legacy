//
//  MainButton.swift
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
        Button(action:
            
        //MARK: Action
        {
        if self.isPaused {
            self.onTap()
        } else {
            self.offTap()
        }
    })
            
            
        //MARK: Layout
        {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .foregroundColor(Color("button.gray"))
                HStack() {
                    Image(systemName: isPaused ? offIcon : onIcon)
                        .padding(.bottom, onIcon == "trash.fill" && !isPaused ? 3 : 0)
                    Text(isPaused ? offTitle : onTitle)
                    
                }
                .foregroundColor(color)
                .smallTitle()
            }.frame(height: 52)
        }
        
    }
}

