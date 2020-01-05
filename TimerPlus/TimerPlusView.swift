//
//  TimerView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/5/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct TimerPlusView: View {
    
    @ObservedObject var timer = TimerPlus()
    
    @State var timeRemaining = 10
    let time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        Button(action: {
            self.timer.title = "Hello there"
        }) {
            VStack(alignment: .leading) {
                Text(timer.title ?? "Timer")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Text(timer.time ?? "0:00")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .opacity(0.5)
                    .onReceive(time) { _ in
                        if self.timeRemaining > 0 {
                            self.timeRemaining -= 1
                            self.timer.time = String(self.timeRemaining)
                        }
                    }
                
            }
        }
        .buttonStyle(BorderlessButtonStyle())
        
        
        
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerPlusView()
    }
}
