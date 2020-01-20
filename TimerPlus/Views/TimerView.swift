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
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.primary)
                    Text("\((self.timer.timeFinished ?? Date()).timeIntervalSince(timer.timeStarted ?? Date()).stringFromTimeInterval(precisionSetting: self.timer.precisionSetting ?? "Off"))")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.primary)
                        .opacity(0.5)
                        .onReceive(Timer.publish(every: 0.015, on: .main, in: .common).autoconnect()) { time in
                            self.timer.updateTime()
                            self.value = "\((self.timer.timeFinished ?? Date()).timeIntervalSince(self.timer.timeStarted ?? Date()).stringFromTimeInterval(precisionSetting: self.timer.precisionSetting ?? "Off"))"
                    }
                    
                }
                if (self.value.count == 8) {
                    Text("88:88:88")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.primary)
                    .opacity(0)
                } else if (self.value.count == 5) {
                    Text("88:88")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.primary)
                    .opacity(0)
                } else {
                    Text("88:88:88.88")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.primary)
                    .opacity(0)
                }
                
            }
        }
        .buttonStyle(DeepButtonStyle())
        .padding(7)
        .fixedSize()
        .contextMenu {
            
            Button(action: {
                self.timer.reset()
            }) {
                Text("Stop")
            }
            Button(action: {
                self.context.delete(self.timer)
            }) {
                Text("Delete")
            }
            Button(action: {
                self.showingDetail.toggle()
            }) {
                Text("Show Details")
            }
        }
        .sheet(isPresented: $showingDetail) {
            TimerDetailView(timer: self.timer, onDismiss: {self.showingDetail = false}, delete: {
                self.context.delete(self.timer)
                self.showingDetail = false
            })
        }
    
        
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
