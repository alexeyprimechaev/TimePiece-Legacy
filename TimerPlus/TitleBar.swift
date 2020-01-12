//
//  TitleBar.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/5/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

let timeCount = TimeCount()

struct TitleBar: View {
    
    @State private var currentTime = Date()
    
    var body: some View {
        HStack {
            Spacer().frame(width:28)
            Text("\(currentTime, formatter: TimerPlus.timeFormatter)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 24)
            Spacer()
        }.frame(height: 75)
        .onReceive(timeCount.currentTimePublisher) { newCurrentTime in
          self.currentTime = newCurrentTime
        }
    }
}

struct TitleBar_Previews: PreviewProvider {
    static var previews: some View {
        TitleBar()
    }
}
