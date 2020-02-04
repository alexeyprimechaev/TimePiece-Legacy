//
//  TimerButton.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/17/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct TimerButton: View {
    
    //MARK: - Properties
    var onTap: () -> ()
    
    
    //MARK: - View
    var body: some View {
        Button(action:
            
        //MARK: Action
        {
            self.onTap()
        })
        
            
        //MARK: Layout
        {
            VStack(alignment: .leading) {
                Text("New")
                    .titleStyle()
                Text("+")
                    .titleStyle()
                    .opacity(0.5)
            }
        }
            
            
        //MARK: Styling
        .buttonStyle(DeepButtonStyle())
        .padding(7)
        .fixedSize()
    }
}
