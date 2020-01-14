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
        
    @Environment(\.managedObjectContext) var context

    var body: some View {
        
        
        Button(action: {
            
            self.timer.changeState()
            
            
        }) {
            VStack(alignment: .leading) {
                Text(timer.title ?? "New Timer")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.primary)
                Text("\((self.timer.timeFinished ?? Date()).timeIntervalSince(timer.timeStarted ?? Date()))")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.primary)
                    .opacity(0.5)
                    .onReceive(Timer.publish(every: 0.015, on: .main, in: .common).autoconnect()) { time in
                        self.timer.updateTime()
                        
                    }
                
            }
        }
        .buttonStyle(BorderlessButtonStyle())
        .padding(7)
        .contextMenu {
            Button(action: {
                self.showingDetail.toggle()
            }) {
                Text("Show Details")
            }.sheet(isPresented: $showingDetail) {
                TimerDetailView(timer: self.timer, onDismiss: {self.showingDetail = false})
            }
        }
    
        
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
