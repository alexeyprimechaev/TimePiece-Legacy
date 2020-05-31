//
//  TabItem.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 5/30/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct TabItem: View {
    
    @State var title = "Tab Item"
    
    @State var icon = "plus"
    
    var action: () -> ()
    
    var body: some View {
        Button(action: {
            self.action()
            regularHaptic()
        }) {
            HStack() {
                Image(systemName: icon)
                Text(title)
            }.padding(14)
        
        }.smallTitle().foregroundColor(.primary)
        
    }
}
