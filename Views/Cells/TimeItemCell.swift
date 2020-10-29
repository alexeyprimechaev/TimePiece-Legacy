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

struct TimeItemCell: View {
//MARK: - Properties
    
    //MARK: Dynamic Propertiess
    @ObservedObject var timeItem: TimeItem
    
    //MARK: CoreData
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var settings: Settings
    
    @State private var currentTime: String = "00:00"
    
    @State private var timeFieldDummy = UITextField()
    @State private var timeFocusedDummy = false
    
//MARK: - View
    var body: some View {
        
        
        Button {
            if timeItem.isStopwatch {
                self.timeItem.togglePause()
            } else {
                if self.timeItem.remainingTime == 0 {
                    if self.timeItem.isReusable {
                        self.timeItem.reset()
                    } else {
                        self.timeItem.remove(from: self.context)
                    }
                } else {
                    self.timeItem.togglePause()
                }
            }
            
            
            try? self.context.save()
        } label: {
            
            Group {
            if !timeItem.isStopwatch {
                VStack(alignment: .leading, spacing: 0) {
                Text(timeItem.title.isEmpty ? Strings.timer : LocalizedStringKey(timeItem.title))
                ZStack(alignment: .topLeading) {
                    if timeItem.isRunning {
                        TimeDisplay(isPaused: $timeItem.isPaused, isRunning: $timeItem.isRunning, timeString: $currentTime, updateTime: updateTime, precisionSetting: $timeItem.precisionSetting, textField: $timeFieldDummy, isFocused: $timeFocusedDummy)
                    }
                    else {
                        TimeDisplay(isPaused: $timeItem.isPaused, isRunning: $timeItem.isRunning, timeString: $timeItem.editableTimeString, updateTime: updateTime, precisionSetting: $timeItem.precisionSetting, textField: $timeFieldDummy, isFocused: $timeFocusedDummy)
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
                        if timeItem.isRunning {
                            TimeDisplay(isPaused: $timeItem.isPaused, isRunning: $timeItem.isRunning, timeString: $currentTime, updateTime: updateTime, precisionSetting: $timeItem.precisionSetting, textField: $timeFieldDummy, isFocused: $timeFocusedDummy)
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
                Text(timeItem.title.isEmpty ? "Stopwatch ⏱" : LocalizedStringKey(timeItem.title))
                    

                    
                    
            }
            }
            }
            
                
                
                // Paused animations

                
                // For layout stability
                

                
                
            .onReceive(Timer.publish(every: 0.015, on: .main, in: .common).autoconnect()) { time in
                self.updateTime()
            }
            .onAppear {
                currentTime = timeItem.remainingTimeString
            }
            .onChange(of: timeItem.remainingTimeString) { newValue in
                currentTime = newValue
            }
            .animation(nil)
        }
        
            
        //MARK: Styling
        .fontSize(.title)
        .buttonStyle(TitleButtonStyle())
        .padding(7)
        .fixedSize()

    
        
    }
    
    func updateTime() {
        
        if timeItem.isStopwatch {
            if !timeItem.isPaused {
                currentTime = Date().timeIntervalSince(timeItem.timeStarted).editableStringMilliseconds()
            } else {
                
            }
            
            
        } else {
            if !timeItem.isPaused {
                
                
                if timeItem.timeFinished.timeIntervalSince(Date()) <= 0 {
                   
                    timeItem.togglePause()
                    
                    timeItem.remainingTime = 0

                    
                    
                    
                    
                    
                    AudioServicesPlaySystemSound(timeItem.soundSetting == TimeItem.soundSettings[0] ? 1007 : 1036)
                    
                    
                    
                    
                    
                }
                
                currentTime = timeItem.timeFinished.timeIntervalSince(Date()).editableStringMilliseconds()

       
            }
        }
        
        
        
    }
}
