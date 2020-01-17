//
//  TimerButton.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/17/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct TimerButton: View {
    
    var onTap: () -> ()
    
    var body: some View {
        Button(action: {
            self.onTap()
        }) {
            VStack(alignment: .leading) {
                Text("New")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.primary)
                Text("+")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.primary)
                    .opacity(0.5)
                
            }
        }
        .buttonStyle(DeepButtonStyle())
        .padding(7)
        .fixedSize()
    }
}
