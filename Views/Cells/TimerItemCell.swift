//
//  TimerItemCell.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/5/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI
import UserNotifications
import AVFoundation

struct TimerItemCell: View {
//MARK: - Properties
    
    //MARK: Dynamic Propertiess
    @ObservedObject var timer: TimerItem
    
    //MARK: CoreData
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var settings: Settings
    
    @State private var currentTime: String = "00:00"
    
    @State private var timeFieldDummy = UITextField()
    @State private var timeFocusedDummy = false
    
//MARK: - View
    var body: some View {
        
        
        Button {
            regularHaptic()
            if timer.isStopwatch {
                self.timer.togglePause()
            } else {
                if self.timer.remainingTime == 0 {
                    if self.timer.isReusable {
                        self.timer.reset()
                    } else {
                        self.timer.remove(from: self.context)
                    }
                } else {
                    self.timer.togglePause()
                }
            }
            
            
            try? self.context.save()
        } label: {
            
            Group {
            if !timer.isStopwatch {
                VStack(alignment: .leading, spacing: 0) {
                Text(timer.title.isEmpty ? Strings.timer : LocalizedStringKey(timer.title))
                ZStack(alignment: .topLeading) {
                    if timer.isRunning {
                        TimeDisplay(isPaused: $timer.isPaused, isRunning: $timer.isRunning, timeString: $currentTime, updateTime: updateTime, precisionSetting: $timer.precisionSetting, textField: $timeFieldDummy, isFocused: $timeFocusedDummy)
                    }
                    else {
                        TimeDisplay(isPaused: $timer.isPaused, isRunning: $timer.isRunning, timeString: $timer.editableTimeString, updateTime: updateTime, precisionSetting: $timer.precisionSetting, textField: $timeFieldDummy, isFocused: $timeFocusedDummy)
                    }
                    HStack(spacing: 0) {
                        if currentTime.prefix(2) != "00" {
                            Text("88").animation(nil)
                            Dots()
                        }
                        Text("88")
                        Dots()
                        Text("88")
            //            Dots(isMilliseconds: true).opacity(isRunning ? isPaused ? 0.25 : 1 : 0.5)
            //            Text(seconds).animation(nil)
            //                .opacity(0.5)
                    }.animation(nil).opacity(0)
                }
                    

                    
                    
            }
            } else {
                VStack(alignment: .leading, spacing: 0) {
                
                ZStack(alignment: .topLeading) {
                    VStack(alignment: .leading, spacing: 0) {
                        if timer.isRunning {
                            TimeDisplay(isPaused: $timer.isPaused, isRunning: $timer.isRunning, timeString: $currentTime, updateTime: updateTime, precisionSetting: $timer.precisionSetting, textField: $timeFieldDummy, isFocused: $timeFocusedDummy)
                        }
                        else {
                            Text("Start").fontSize(.title).opacity(0.5)
                        }
                    }.animation(.default)
                    
                    HStack(spacing: 0) {
                        if currentTime.prefix(2) != "00" {
                            Text("88").animation(nil)
                            Dots()
                        }
                        Text("88")
                        Dots()
                        Text("88")
            //            Dots(isMilliseconds: true).opacity(isRunning ? isPaused ? 0.25 : 1 : 0.5)
            //            Text(seconds).animation(nil)
            //                .opacity(0.5)
                    }.animation(nil).opacity(0)
                }
                Text(timer.title.isEmpty ? Strings.timer : LocalizedStringKey(timer.title))
                    

                    
                    
            }
            }
            }
            
                
                
                // Paused animations

                
                // For layout stability
                

                
                
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
        .fontSize(.title)
        .buttonStyle(RegularButtonStyle())
        .padding(7)
        .fixedSize()

    
        
    }
    
    func updateTime() {
        
        if timer.isStopwatch {
            if !timer.isPaused {
                currentTime = Date().timeIntervalSince(timer.timeStarted).editableStringMilliseconds()
            } else {
                
            }
            
            
        } else {
            if !timer.isPaused {
                
                
                if timer.timeFinished.timeIntervalSince(Date()) <= 0 {
                   
                    timer.togglePause()
                    
                    timer.remainingTime = 0

                    
                    
                    
                    
                    
                    AudioServicesPlaySystemSound(timer.soundSetting == TimerItem.soundSettings[0] ? 1007 : 1036)
                    
                    
                    
                    
                    
                }
                
                currentTime = timer.timeFinished.timeIntervalSince(Date()).editableStringMilliseconds()

       
            }
        }
        
        
        
    }
}
