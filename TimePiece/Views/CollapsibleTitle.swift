//
//  CollapsibleTitle.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 2/25/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct CollapsibleSection: View {
    
    @State var isSmall = false
    
    @State var content: some View
    
    var body: some View {
        VStack() {
            
            Text("yo")
                .font(.system(size: isSmall ? 17 : 34, weight: isSmall ? .semibold : .bold))
                .onTapGesture {
                    self.isSmall.toggle()
            }
        }
    }
}

struct CollapsibleTitle_Previews: PreviewProvider {
    static var previews: some View {
        CollapsibleSection()
    }
}
