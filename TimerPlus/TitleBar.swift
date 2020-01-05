//
//  TitleBar.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/5/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct TitleBar: View {
    var body: some View {
        HStack {
            Spacer().frame(width:28)
            Text("Timer+")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 24)
            Spacer()
        }.frame(height: 75)
    }
}

struct TitleBar_Previews: PreviewProvider {
    static var previews: some View {
        TitleBar()
    }
}
