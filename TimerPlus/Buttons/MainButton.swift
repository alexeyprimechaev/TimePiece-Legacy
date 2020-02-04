//
//  MainButton.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/13/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct MainButton: View {
    
//MARK: - Properties
    
    
    
    //MARK: Dynamic Properties
    @State var color: Color
    @Binding var isPaused: NSNumber?
    
    
    //MARK: Configured Properties
    var offTitle = String()
    var onTitle = String()
    
    var offIcon = String()
    var onIcon = String()
    
    var onTap: () -> ()
    var offTap: () -> ()
    
//MARK: - View
    var body: some View {
        Button(action:
            
        //MARK: Action
        {
        if (self.isPaused?.boolValue ?? false) {
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
                    Image(systemName: isPaused?.boolValue ?? false ? offIcon : onIcon)
                        .padding(.bottom, onIcon == "trash.fill" && !(isPaused?.boolValue ?? false) ? 3 : 0)
                    Text(isPaused?.boolValue ?? false ? offTitle : onTitle)
                    
                }
                .foregroundColor(color)
                .smallTitleStyle()
            }.frame(height: 52)
        }
        
    }
}

