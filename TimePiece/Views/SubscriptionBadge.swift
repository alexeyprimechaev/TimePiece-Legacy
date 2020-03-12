//
//  SubscriptionBadge.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 3/10/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct SubscriptionBadge: View {
    
    var icon = String()
    var title = String()
    var subtitle = String()
    
    var iconOffset: CGFloat = 0
    var textOffset: CGFloat = 0
    
    var body: some View {
        HStack(alignment: .center, spacing: 21) {
            Image(systemName: icon).font(.system(size: 34, weight: .regular)).offset(y: iconOffset)
            VStack(alignment: .leading, spacing: 4) {
                Text(title).smallTitleStyle()
                if subtitle != String() {
                    Text(subtitle)
                }
            }.offset(x: textOffset)
        }.padding(7)
    }
}

struct SubscriptionBadge_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionBadge()
    }
}
