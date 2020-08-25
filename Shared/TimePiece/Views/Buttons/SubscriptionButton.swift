//
//  SubscriptionButton.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 4/20/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct SubscriptionButton: View {
    
    
    @State var title = LocalizedStringKey("")
    
    @State var promo = LocalizedStringKey("")
    
    @State var price = ""
    
    @State var duration = LocalizedStringKey("")
    
    @State var isAccent = false
    
    
    var action: () -> ()
    
    var body: some View {
        
        Button(action: {
            self.action()
        }) {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .foregroundColor(isAccent ? Color("priority.gray") : Color("button.gray"))
                HStack() {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title).smallTitle()
                        Text(promo).font(.system(size: 12, weight: .medium, design: .default))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(price).smallTitle()
                        Text(duration).font(.system(size: 12, weight: .medium, design: .default))
                    }
                }.foregroundColor(isAccent ? Color(.systemBackground) : Color.primary).padding(.horizontal, 14)
            }.frame(height: 66)
        }
    }
}

