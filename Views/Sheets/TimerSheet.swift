//
//  TimerPlusDetailView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/6/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI
import Introspect
import AVFoundation
import CoreData

struct TimerSheet: View {
    
    @ObservedObject var timer = TimerItem()
    
    @EnvironmentObject var settings: Settings
        
    @State var name = ""
    
    @State var currentTime: String = "00:00"
    @State var totalTime: String = "00:00"
    
    var discard: () -> ()
    
    var delete: () -> ()
    
    var body: some View {
        
        VStack(spacing:0) {
            HeaderBar(
            leadingAction: {
                self.discard()
            }, leadingTitle: dismissString, leadingIcon: "chevron.down", leadingIsDestructive: false,
            trailingAction: {})
            
            ScrollView() {
                
                VStack(alignment: .leading, spacing: 14) {
                        
                    PropertyView(title: titleString, timer: timer).disabled(!timer.isPaused)
                    
                    VStack(alignment: .leading, spacing:14) {
                        if timer.isRunning {
                            TimeDisplay(isPaused: $timer.isPaused, isRunning: $timer.isRunning, timeString: $currentTime, updateTime: {updateTime()}, isOpaque: true, displayStyle: .labeled, label: leftString, precisionSetting: $timer.precisionSetting)
                        }
                        TimeDisplay(isPaused: $timer.isPaused, isRunning: $timer.isRunning, timeString: $timer.editableTimeString, updateTime: {updateTime()}, isOpaque: true, displayStyle: .labeled, label: totalString, precisionSetting: $timer.precisionSetting)
                        
                        
                    }.animation(Animation.default, value: timer.isRunning)
                        
                    VStack(alignment: .leading, spacing:14) {
                        if timer.isReusable {
                            PickerButton(title: notificationString, values: TimerItem.notificationSettings, value: $timer.notificationSetting)
                            PickerButton(title: soundString, values: TimerItem.soundSettings, value: $timer.soundSetting)
                            PremiumBadge() {
                                PickerButton(title: millisecondsString, values: TimerItem.precisionSettings, value: self.$timer.precisionSetting)
                            }

                            PremiumBadge() {
                                PickerButton(title: showInLogString, values: [true.yesNo, false.yesNo], value: self.$timer.showInLog.yesNo)
                            }
                        } else {
                            
                            PremiumBadge() {
                                RegularButton(title: makeReusableString, subtitle: "", action: self.timer.makeReusable)
                            }
                            
                        }

                    }.animation(Animation.default, value: timer.isReusable)
                    
                }.animation(Animation.default, value: timer.isRunning)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .padding(.leading, 21)
                .onAppear {
                    currentTime = timer.remainingTimeString
                }
                .onReceive(Timer.publish(every: 0.015, on: .main, in: .common).autoconnect()) { time in
                    self.updateTime()
                    print(timer.remainingTime)
                }

            }
            
            HStack() {
                Spacer().frame(width:28)
                if timer.isReusable {
                    PauseButton(color: Color.red, isPaused: $timer.isRunning, offTitle: timer.remainingTime == 0 ? resetString : stopString, onTitle: deleteString, offIcon: "stop.fill", onIcon: "trash.fill",
                                onTap: {
                                    self.timer.reset()
                                    mediumHaptic()
                                },
                                offTap: {
                                    self.delete()
                                    mediumHaptic()
                                }
                    )
                } else {
                    PauseButton(color: Color.red, isPaused: $timer.isReusable, offTitle: deleteString, onTitle: deleteString, offIcon: "trash.fill", onIcon: "trash.fill", onTap: {self.delete()}, offTap: {self.delete()})
                }
                Spacer().frame(width:28)
                PauseButton(color: Color.primary, isPaused: $timer.isPaused, offTitle: startString, onTitle: pauseString, offIcon: "play.fill", onIcon: "pause.fill", onTap: {
                        regularHaptic()
                        if self.timer.remainingTime == 0 {
                            if self.timer.isReusable {
                                self.timer.reset()
                            } else {
                                self.delete()
                            }
                        } else {
                            self.timer.togglePause()
                        }
                    
                }, offTap: {
                    regularHaptic()
                    if self.timer.remainingTime == 0 {
                        if self.timer.isReusable {
                            self.timer.reset()
                        } else {
                            self.delete()
                        }
                    } else {
                        self.timer.togglePause()
                    }
                })
                Spacer().frame(width:28)
                
            }.padding(.vertical, 7)
        }
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

struct TimerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TimerSheet(discard: {}, delete: {})
    }
}
