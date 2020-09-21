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
    
    @State var titleField = UITextField()
    @State var timeField = UITextField()
    
    
    
    @State var titleFocused = false
    @State var timeFocused = false
    
    @State var timeFieldDummy = UITextField()
    @State var timeFocusedDummy = false
    
    var discard: () -> Void
    
    var delete: () -> Void
    
    var body: some View {
        
        VStack(spacing:0) {
            HeaderBar(leadingAction: discard,
                      leadingTitle: Strings.dismiss,
                      leadingIcon: "chevron.down",
                      leadingIsDestructive: false,
                      trailingAction: {})
            ScrollView {
                
                VStack(alignment: .leading, spacing: 14) {
                        
                    TitleEditor(title: Strings.title, timer: timer, textField: $titleField, isFocused: $titleFocused).disabled(!timer.isPaused)
                    
                    VStack(alignment: .leading, spacing:14) {
                        if timer.isRunning {
                            TimeDisplay(isPaused: $timer.isPaused, isRunning: $timer.isRunning, timeString: $currentTime, updateTime: updateTime, isOpaque: true, displayStyle: .labeled, label: Strings.left, precisionSetting: $timer.precisionSetting, textField: $timeFieldDummy, isFocused: $timeFocusedDummy)
                        }
                        TimeDisplay(isPaused: $timer.isPaused, isRunning: $timer.isRunning, timeString: $timer.editableTimeString, updateTime: {updateTime()}, isOpaque: true, displayStyle: .labeled, label: Strings.total, precisionSetting: $timer.editableTimeString, textField: $timeField, isFocused: $timeFocused)
                        
                        
                    }.animation(Animation.default, value: timer.isRunning)
                        
                    VStack(alignment: .leading, spacing:14) {
                        if timer.isReusable {
                            PickerButton(title: Strings.notification, values: TimerItem.notificationSettings, controlledValue: $timer.notificationSetting)
                            PickerButton(title: Strings.sound, values: TimerItem.soundSettings, controlledValue: $timer.soundSetting)
                            PremiumBadge {
                                PickerButton(title: Strings.milliseconds, values: TimerItem.precisionSettings, controlledValue: $timer.precisionSetting)
                            }

                            PremiumBadge {
                                PickerButton(title: Strings.showInLog, values: [true.yesNo, false.yesNo], controlledValue: $timer.showInLog.yesNo)
                            }
                        } else {
                            
                            PremiumBadge {
                                RegularButton(title: Strings.makeReusable, subtitle: "", action: timer.makeReusable)
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
                    updateTime()
                }

            }
            
            if titleFocused || timeFocused {
                EditorBar(titleField: $titleField, timeField: $timeField, titleFocused: $titleFocused, timeFocused: $timeFocused) {
                    Button {
                        titleField.resignFirstResponder()
                        timeField.resignFirstResponder()
                    } label: {
                        Label {
                            Text("Done").fontSize(.smallTitle)
                        } icon: {
                            
                        }.padding(.horizontal, 14).padding(.vertical, 7).background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                                .foregroundColor(Color("button.gray"))).padding(.vertical, 7)
                    }
                }
            } else {
                HStack {
                    Spacer().frame(width:28)
                    if timer.isReusable {
                        PauseButton(color: Color.red, isPaused: $timer.isRunning, offTitle: timer.remainingTime == 0 ? Strings.reset : Strings.stop, onTitle: Strings.delete, offIcon: "stop.fill", onIcon: "trash.fill",
                                    onTap: {
                                        timer.reset()
                                        mediumHaptic()
                                    },
                                    offTap: {
                                        delete()
                                        mediumHaptic()
                                    }
                        )
                    } else {
                        PauseButton(color: Color.red, isPaused: $timer.isReusable, offTitle: Strings.delete, onTitle: Strings.delete, offIcon: "trash.fill", onIcon: "trash.fill", onTap: delete, offTap: delete)
                    }
                    Spacer().frame(width:28)
                    PauseButton(color: Color.primary, isPaused: $timer.isPaused, offTitle: Strings.start, onTitle: Strings.pause, offIcon: "play.fill", onIcon: "pause.fill", onTap: {
                            regularHaptic()
                            if timer.remainingTime == 0 {
                                if timer.isReusable {
                                    timer.reset()
                                } else {
                                    delete()
                                }
                            } else {
                                timer.togglePause()
                            }
                        
                    }, offTap: {
                        regularHaptic()
                        if timer.remainingTime == 0 {
                            if timer.isReusable {
                                timer.reset()
                            } else {
                                delete()
                            }
                        } else {
                            timer.togglePause()
                        }
                    })
                    Spacer().frame(width:28)
                    
                }.padding(.vertical, 7)
            }
            
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
          
   
        }
        
    }
    
}

struct TimerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TimerSheet(discard: {}, delete: {})
    }
}
