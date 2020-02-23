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
//MARK: - Properties
    
    //MARK: Dynamic Propertiess
    @ObservedObject var timer = TimerPlus()
    @State var showingDetail = false
    @State var value = "88:88"
    
    //MARK: CoreData
    @Environment(\.managedObjectContext) var context

    
//MARK: - View
    var body: some View {
        
        
        Button(action:
            
        //MARK: Action
        {
            if self.timer.currentTime == 0 {
                if self.timer.isReusable {
                    self.timer.reset()
                } else {
                    self.timer.remove(from: self.context)
                }
            } else {
                self.timer.togglePause()
            }
        })
            
            
        //MARK: Layout
        {
            ZStack(alignment: .bottomLeading) {
                VStack(alignment: .leading) {
                    Text(timer.title.isEmpty ? "Timer ⏱" : timer.title)
                    
                    Text(timer.currentTime.stringFromTimeInterval(precisionSetting: timer.precisionSetting))
                        .opacity(0.5)
                        .onReceive(Timer.publish(every: 0.015, on: .main, in: .common).autoconnect()) { time in
                            self.timer.updateTime()
                            self.value = self.timer.currentTime.stringFromTimeInterval(precisionSetting: self.timer.precisionSetting)

                        }
                    
                }
                
                Rectangle().foregroundColor(Color(UIColor.systemBackground))
                .frame(width: 100, height: 40)
                    .opacity(timer.currentTime == 0 ? 0.5 : 0)
                    .animation(timer.currentTime == 0 ? Animation.easeOut(duration: 0.5).repeatForever() : Animation.linear, value: timer.isPaused)
                
                if timer.currentTime != 0 {
                    HStack(spacing: 0) {
                        Text(timer.currentTime.stringFromTimeInterval(precisionSetting: timer.precisionSetting).prefix(2))
                            .opacity(0)
                        Rectangle().frame(width:9, height: 40)
                            .foregroundColor(Color(UIColor.systemBackground))
                            .opacity(timer.isRunning && timer.isPaused ? 0.7 : 0)
                        if timer.currentTime.stringFromTimeInterval(precisionSetting: timer.precisionSetting).count > 5 {
                            Text(timer.currentTime.stringFromTimeInterval(precisionSetting: timer.precisionSetting).prefix(5).suffix(2))
                                .opacity(0)
                            Rectangle().frame(width:8, height: 40)
                                .foregroundColor(Color(UIColor.systemBackground))
                                .opacity(timer.isRunning && timer.isPaused ? 0.7 : 0)
                        }
                        if timer.currentTime.stringFromTimeInterval(precisionSetting: timer.precisionSetting).count > 8 {
                            Text(timer.currentTime.stringFromTimeInterval(precisionSetting: timer.precisionSetting).prefix(8).suffix(2))
                                .opacity(0)
                            Rectangle().frame(width:9, height: 40)
                                .foregroundColor(Color(UIColor.systemBackground))
                                .opacity(timer.isRunning && timer.isPaused ? 0.7 : 0)
                        }
                    }
                    .animation(timer.isRunning && timer.isPaused ? Animation.easeOut(duration: 0.5).repeatForever() : Animation.linear, value: timer.isPaused)
                }
                Group {
                    if self.value.count == 8 {
                        Text("88:88:88")
                            .opacity(0)
                    } else if self.value.count == 5 {
                        Text("88:88")
                            .opacity(0)
                        
                    } else {
                        Text("88:88:88.88")
                            .opacity(0)
                    }
                }

                
                
            }
        }
        
            
        //MARK: Styling
        .titleStyle()
        .buttonStyle(RegularButtonStyle())
        .padding(7)
        .fixedSize()
    
        
    }
}

//MARK: - Previews
struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
