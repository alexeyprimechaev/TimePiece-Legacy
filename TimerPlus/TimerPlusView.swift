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
    
    @State var showingDetail = false
        
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        
        
        Button(action: {
            if(self.timer.isPaused ?? true).boolValue {
                self.timer.timeStarted = Date()
                self.timer.timeFinished = self.timer.timeStarted?.addingTimeInterval(self.timer.time as! TimeInterval)
                print(self.timer.timeStarted)
                print("\(self.timer.timeFinished)heyy")
                self.timer.isPaused = false
            } else {
                self.timer.isPaused = true
            }
            
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
                    .onReceive(Timer.publish(every: 0.015, on: .main, in: .common).autoconnect()) { newCurrentTime in
                        if !(self.timer.isPaused?.boolValue ?? true
                            ) {
                            self.timer.timeStarted = newCurrentTime
                            if (self.timer.time!.doubleValue <= 0) {
                                self.timer.time = 60
                            }
                            self.timer.time = self.timer.time as! Double - 0.015 as NSNumber
                            
                        }
                        
                    }
                
            }
        }
        .buttonStyle(BorderlessButtonStyle())
            
        .padding(7)
        
        .contextMenu {
            Button(action: {
                self.context.delete(self.timer)
            }) {
                Text("Delete")
            }.foregroundColor(.red)

            Button(action: {
                self.showingDetail.toggle()
            }) {
                Text("Show Info")
                Image(systemName: "location.circle")
            }.sheet(isPresented: $showingDetail) {
                TimerPlusDetailView(timer: self.timer, onDismiss: {self.showingDetail.toggle()})
            }
        }
        
        
        
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerPlusView()
    }
}
