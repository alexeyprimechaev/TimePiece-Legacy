//
//  TimerPlusDetailView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/6/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI
import Introspect
import CoreData

struct TimerSheet: View {
    
    @ObservedObject var timer = TimerItem()
    
    @EnvironmentObject var settings: Settings
        
    @State var name = ""
    
    var discard: () -> ()
    
    var delete: () -> ()
    
    var body: some View {
        
        VStack(spacing:0) {
            HeaderBar(
            leadingAction: {
                self.discard()
            }, leadingTitle: dismissString, leadingIcon: "xmark", leadingIsDestructive: false,
            trailingAction: {})
            
            ScrollView() {
                
                VStack(alignment: .leading, spacing: 14) {
                        
                    PropertyView(title: titleString, timer: timer).disabled(!timer.isPaused)
                    
                    if timer.totalTimeString.count + timer.timeFinished.timeIntervalSince(timer.timeStarted).stringFromTimeInterval(precisionSetting: timer.precisionSetting).count > 13 {
                        VStack(alignment: .leading, spacing:14) {
                            if timer.totalTime != timer.currentTime {
                                TimeView(time: $timer.currentTime, precisionSetting: $timer.precisionSetting, title: leftString, update: {})
                            }
                            EditableTimeView(time: $timer.totalTime, title: totalString, update: {
                                self.timer.reset()
                                self.timer.currentTime = self.timer.totalTime
                            })
                            .disabled(timer.isRunning)
                        }.animation(Animation.default, value: timer.isRunning)
                    } else {
                        HStack(alignment: .top) {
                            
                            if timer.isRunning {
                                TimeView(time: $timer.currentTime, precisionSetting: $timer.precisionSetting, title: leftString, update: {})

                            }
                        
                            EditableTimeView(time: $timer.totalTime, title: totalString, update: {
                                self.timer.reset()
                                self.timer.currentTime = self.timer.totalTime
                            })
                            .disabled(timer.isRunning)
                        }.animation(Animation.default, value: timer.isRunning)
                    }
                        
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

            }
            
            HStack() {
                Spacer().frame(width:28)
                if timer.isReusable {
                    PauseButton(color: Color.red, isPaused: $timer.isRunning, offTitle: timer.currentTime == 0 ? resetString : stopString, onTitle: deleteString, offIcon: "stop.fill", onIcon: "trash.fill",
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
                        if self.timer.currentTime == 0 {
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
                    if self.timer.currentTime == 0 {
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
    
}

struct TimerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TimerSheet(discard: {}, delete: {})
    }
}
