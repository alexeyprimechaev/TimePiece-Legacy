//
//  TimerView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/5/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct TimerView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Eggs 🍳")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("3:29")
                .font(.largeTitle)
                .fontWeight(.bold)
                .opacity(0.5)
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
