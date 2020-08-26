//
//  TimerView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/5/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI
import UserNotifications
import AVFoundation

struct TimerView: View {
//MARK: - Properties
    
    //MARK: Dynamic Propertiess
    @ObservedObject var timer = TimerItem()
    
    //MARK: CoreData
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var settings: Settings
    
    @State var currentTime: String = "00:00"
    
//MARK: - View
    var body: some View {
        
        
        Button(action:
            
        //MARK: Action
        {
            regularHaptic()
            if self.timer.remainingTime == 0 {
                if self.timer.isReusable {
                    self.timer.reset()
                } else {
                    self.timer.remove(from: self.context)
                }
            } else {
                self.timer.togglePause()
            }
            
            try? self.context.save()
        })
            
            
        //MARK: Layout
        {
            ZStack(alignment: .bottomLeading) {
                VStack(alignment: .leading) {
                    Text(timer.title.isEmpty ? timerString : LocalizedStringKey(timer.title))
                    
                    Text(currentTime)
                        .opacity(0.5)
                    
                }
                
                Rectangle().foregroundColor(Color(UIColor.systemBackground))
                .frame(width: 100, height: 40)
                    .opacity(timer.remainingTime == 0 ? 0.5 : 0)
                    .animation(timer.remainingTime == 0 ? Animation.easeOut(duration: 0.5).repeatForever() : Animation.linear, value: timer.isPaused)
                
                // Paused animations
                if timer.remainingTime != 0 {
                    HStack(spacing: 0) {
                        Text(timer.remainingTimeString.prefix(2))
                            .opacity(0)
                        Rectangle().frame(width:9, height: 40)
                            .foregroundColor(Color(UIColor.systemBackground))
                            .opacity(timer.isRunning && timer.isPaused ? 0.7 : 0)
                        if timer.remainingTimeString.count > 5 {
                            Text(timer.remainingTimeString.prefix(5).suffix(2))
                                .opacity(0)
                            Rectangle().frame(width:8, height: 40)
                                .foregroundColor(Color(UIColor.systemBackground))
                                .opacity(timer.isRunning && timer.isPaused ? 0.7 : 0)
                        }
                        if timer.remainingTimeString.count > 8 {
                            Text(timer.remainingTimeString.prefix(8).suffix(2))
                                .opacity(0)
                            Rectangle().frame(width:9, height: 40)
                                .foregroundColor(Color(UIColor.systemBackground))
                                .opacity(timer.isRunning && timer.isPaused ? 0.7 : 0)
                        }
                    }
                    .animation(timer.isRunning && timer.isPaused ? Animation.easeOut(duration: 0.5).repeatForever() : Animation.linear, value: timer.isPaused)
                }
                
                // For layout stability
                Group {
                    if self.timer.remainingTime.stringFromTimeInterval(precisionSetting: self.timer.precisionSetting).count >= 11  {
                        Text("88:88:88:88")
                    } else if self.timer.remainingTime.stringFromTimeInterval(precisionSetting: self.timer.precisionSetting).count >= 8 {
                        Text("88:88:88")
                        
                    } else {
                        Text("88:88")
                    }
                }.opacity(0)
                

                
                
            }
            .onReceive(Timer.publish(every: 0.015, on: .main, in: .common).autoconnect()) { time in
                self.updateTime()
            }
            .onAppear {
                currentTime = timer.remainingTimeString
            }
            .onChange(of: timer.remainingTimeString) { newValue in
                currentTime = newValue
            }
            .animation(nil)
        }
        
            
        //MARK: Styling
        .title()
        .buttonStyle(RegularButtonStyle())
        .padding(7)
        .fixedSize()

    
        
    }
    
    func updateTime() {
        
        if !timer.isPaused {
            
            
            if timer.timeFinished.timeIntervalSince(Date()) <= 0 {
               
                timer.togglePause()
                
                timer.remainingTime = 0

                AudioServicesPlaySystemSound(timer.soundSetting == TimerItem.soundSettings[0] ? 1007 : 1036)
            }
            
            currentTime = timer.timeFinished.timeIntervalSince(Date()).stringFromTimeInterval(precisionSetting: timer.precisionSetting)
   
        }
        
    }
}

//MARK: - Previews
struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
