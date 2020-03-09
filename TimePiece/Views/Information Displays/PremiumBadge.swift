//
//  PremiumBadge.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 3/5/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct PremiumBadge: View {
    
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Image(systemName: "star.fill").font(.system(size: 9, weight: .semibold, design: settings.fontDesign)).padding(.trailing, 3)
            Text("PLUS").font(.system(size: 13, weight: .semibold, design: settings.fontDesign))
        }.padding(.leading, 9)
        
    }
}

struct PremiumBadge_Previews: PreviewProvider {
    static var previews: some View {
        PremiumBadge()
    }
}
