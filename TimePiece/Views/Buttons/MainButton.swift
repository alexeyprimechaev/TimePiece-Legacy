//
//  MainButton.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 3/9/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct MainButton: View {
    
    @State var icon = String()
    @State var title = String()
    
    @State var highPriority = false
    
    var action: () -> ()
    
    var body: some View {
        Button(action: {
            self.action()
        }) {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .foregroundColor(highPriority ? Color("priority.gray") : Color("button.gray"))
                Label(title, systemImage: icon)
                .foregroundColor(highPriority ? Color(UIColor.systemBackground) : Color.primary)
                .smallTitle()
            }.frame(height: 52)
               
            
        }
    }
}
