//
//  MainButton.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/13/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct MainButton: View {
    
    @State var title = String()
    
    @Binding var isOn: NSNumber?
    
    var offTitle = String()
    var onTitle = String()
    
    var body: some View {
        Button(action: {
            
        }) {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .foregroundColor(Color(UIColor.systemGray6))
                Text(title)
                    .foregroundColor(Color.primary)
            }.frame(height: 52)
        }
        
    }
}

