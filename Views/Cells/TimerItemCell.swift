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
            VStack(alignment: .leading, spacing: 0) {
                    Text(timer.title.isEmpty ? timerString : LocalizedStringKey(timer.title))
                ZStack(alignment: .topLeading) {
                    if timer.isRunning {
                        TimeDisplay(isPaused: $timer.isPaused, isRunning: $timer.isRunning, timeString: $currentTime, updateTime: {updateTime()}, precisionSetting: $timer.precisionSetting)
                    }
                    else {
                        TimeDisplay(isPaused: $timer.isPaused, isRunning: $timer.isRunning, timeString: $timer.editableTimeString, updateTime: {updateTime()}, precisionSetting: $timer.precisionSetting)
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
            
            currentTime = timer.timeFinished.timeIntervalSince(Date()).editableStringMilliseconds()
            print(currentTime)
            print(timer.remainingTimeString)
   
        }
        
    }
}

//MARK: - Previews
struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerItemCell()
    }
}
