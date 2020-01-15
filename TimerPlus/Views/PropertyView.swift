//
//  PropertyView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/16/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct PropertyView: View {
    
    @State var title = String()
    
    @Binding var property: String?
    
    @State var propertyValue = String()
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 7) {
            Text(propertyValue)
                .font(.largeTitle)
                .fontWeight(.bold)
                .opacity(1)
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.bottom, 5)
                .opacity(0.5)
        }
    }
}

