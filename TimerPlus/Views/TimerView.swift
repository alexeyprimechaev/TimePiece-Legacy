//
//  TimerView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/5/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI
import UserNotifications

struct TimerView: View {
    
    @ObservedObject var timer = TimerPlus()
    
    @State var showingDetail = false
    
    @State var value = "88:88"
        
    @Environment(\.managedObjectContext) var context

    var body: some View {
        
        
        Button(action: {
            self.timer.togglePause()
        }) {
            ZStack(alignment: .bottomLeading) {
                VStack(alignment: .leading) {
                    Text(timer.title ?? "New Timer")
                    
                    Text("\((timer.timeFinished ?? Date()).timeIntervalSince(timer.timeStarted ?? Date()).stringFromTimeInterval(precisionSetting: timer.precisionSetting ?? "Off"))")
                        .opacity(0.5)
                        .onReceive(Timer.publish(every: 0.015, on: .main, in: .common).autoconnect()) { time in
                            self.timer.updateTime()
                            self.value = "\((self.timer.timeFinished ?? Date()).timeIntervalSince(self.timer.timeStarted ?? Date()).stringFromTimeInterval(precisionSetting: self.timer.precisionSetting ?? "Off"))"
                    }
                    
                }
                if (self.value.count == 8) {
                    Text("88:88:88")
                        .opacity(0)
                } else if (self.value.count == 5) {
                    Text("88:88")
                        .opacity(0)
                } else {
                    Text("88:88:88.88")
                        .opacity(0)
                }
                
            }
        }
        .titleStyle()
        .buttonStyle(DeepButtonStyle())
        .padding(7)
        .fixedSize()
    
        
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
