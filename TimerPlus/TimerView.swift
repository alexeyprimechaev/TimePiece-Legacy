//
//  TimerView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/5/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct TimerView: View {
    
    @ObservedObject var timer = TimerPlus()
    
    @State var showingDetail = false
        
    @Environment(\.managedObjectContext) var context

    var body: some View {
        
        
        Button(action: {
            if(self.timer.isPaused ?? true).boolValue {
                self.timer.timeStarted = Date()
                self.timer.timeFinished = self.timer.timeStarted?.addingTimeInterval(self.timer.time as! TimeInterval)
                self.timer.isPaused = false
                print("Button: \(self.timer.timeStarted!.timeIntervalSince1970)")
                print("Button: \(self.timer.timeFinished!.timeIntervalSince1970)")
            } else {

                self.timer.timeStarted = Date()
                self.timer.time = ((self.timer.timeFinished ?? Date()).timeIntervalSince(self.timer.timeStarted ?? Date())) as NSNumber
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
                            
                            print("Timer: \(self.timer.timeStarted!.timeIntervalSince1970)")
                            print("Timer: \(self.timer.timeFinished!.timeIntervalSince1970)")
                            
                            self.timer.timeStarted = newCurrentTime
                            self.timer.time = ((self.timer.timeFinished ?? Date()).timeIntervalSince(self.timer.timeStarted ?? Date())) as NSNumber
                            
                            if (self.timer.time!.doubleValue <= 0) {
                                print("fuck")
                                self.timer.time = 5
                                self.timer.timeStarted = Date()
                                self.timer.timeFinished = self.timer.timeStarted?.addingTimeInterval(self.timer.time as! TimeInterval)
                                self.timer.isPaused = true
                            }
                            
                            
                            
                        }
                        
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
                TimerDetailView(timer: self.timer, onDismiss: {self.showingDetail.toggle()})
            }
        }
    
        
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
