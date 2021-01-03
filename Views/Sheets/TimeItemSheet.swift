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

struct TimeItemSheet: View {
    
    @ObservedObject var timeItem = TimeItem()
    
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
                        
                    TitleEditor(title: Strings.title, timeItem: timeItem, textField: $titleField, isFocused: $titleFocused).disabled(!timeItem.isPaused)
                    
                        if timeItem.isRunning {
                            TimeDisplay(isPaused: $timeItem.isPaused, isRunning: $timeItem.isRunning, timeString: $currentTime, updateTime: updateTime, isOpaque: true, displayStyle: .labeled, label: timeItem.isStopwatch ? Strings.total : Strings.left, precisionSetting: $timeItem.precisionSetting, textField: $timeFieldDummy, isFocused: $timeFocusedDummy)
                        }
                        
                        if !timeItem.isStopwatch {
                            TimeDisplay(isPaused: $timeItem.isPaused, isRunning: $timeItem.isRunning, timeString: $timeItem.editableTimeString, updateTime: {updateTime()}, isOpaque: true, displayStyle: .labeled, label: Strings.total, precisionSetting: $timeItem.editableTimeString, textField: $timeField, isFocused: $timeFocused)
                        }
                        
                        
                    
                    
                        
                    VStack(alignment: .leading, spacing:14) {
                        if timeItem.isReusable {
                            ContinousPicker()
                            PickerButton(title: Strings.notification, values: TimeItem.notificationSettings, controlledValue: $timeItem.notificationSetting)
                            PickerButton(title: Strings.sound, values: TimeItem.soundSettings, controlledValue: $timeItem.soundSetting)
                            PremiumBadge {
                                PickerButton(title: Strings.milliseconds, values: TimeItem.precisionSettings, controlledValue: $timeItem.precisionSetting)
                            }

                            PremiumBadge {
                                PickerButton(title: Strings.showInLog, values: [true.yesNo, false.yesNo], controlledValue: $timeItem.showInLog.yesNo)
                            }
                        } else {
                            
                            PremiumBadge {
                                RegularButton(title: Strings.makeReusable) {
                                    timeItem.makeReusable()
                                }
                            }
                            
                        }
                        
                        VStack(alignment: .leading, spacing: 7) {
                            Group {
                                if !timeItem.isStopwatch {
                                    
                                    RegularButton(title: "Convert to Stopwatch", icon: "stopwatch") {
                                        self.timeItem.isStopwatch = true
                                    }
                                    
                                } else {
                                    RegularButton(title: "Convert to Timer", icon: "timer") {
                                        self.timeItem.isStopwatch = false
                                    }
                                }
                            }
//                            
//                            RegularButton(title: "Add to Sequence", icon: "chevron.right.2") {
//                                
//                            }
//                            
//                            RegularButton(title: "Show History", icon: "clock") {
//                                
//                            }
                        }
                        

                    }.animation(Animation.default, value: timeItem.isReusable)
                    
                }.animation(Animation.default, value: timeItem.isRunning)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .padding(.leading, 21)
                .onAppear {
                    currentTime = timeItem.remainingTimeString
                }
                .onReceive(Timer.publish(every: 0.015, on: .main, in: .common).autoconnect()) { time in
                    updateTime()
                }

            }.animation(.default)
            
            if titleFocused || timeFocused {
                EditorBar(titleField: $titleField, timeField: $timeField, titleFocused: $titleFocused, timeFocused: $timeFocused, showSwitcher: $timeItem.isStopwatch) {
                    if timeItem.isStopwatch {
                        Spacer()
                    }
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
                    if timeItem.isReusable {
                        PauseButton(color: Color.red, isPaused: $timeItem.isRunning, offTitle: timeItem.remainingTime == 0 ? Strings.reset : Strings.stop, onTitle: Strings.delete, offIcon: "stop.fill", onIcon: "trash.fill",
                                    onTap: {
                                        timeItem.reset()
                                    },
                                    offTap: {
                                        delete()
                                    }
                        )
                    } else {
                        PauseButton(color: Color.red, isPaused: $timeItem.isReusable, offTitle: Strings.delete, onTitle: Strings.delete, offIcon: "trash.fill", onIcon: "trash.fill", onTap: delete, offTap: delete)
                    }
                    Spacer().frame(width:28)
                    PauseButton(color: Color.primary, isPaused: $timeItem.isPaused, offTitle: Strings.start, onTitle: Strings.pause, offIcon: "play.fill", onIcon: "pause.fill", onTap: {
                            if timeItem.isStopwatch {
                                self.timeItem.togglePause()
                            } else {
                                if self.timeItem.remainingTime == 0 {
                                    if self.timeItem.isReusable {
                                        self.timeItem.reset()
                                    } else {
                                        delete()
                                    }
                                } else {
                                    self.timeItem.togglePause()
                                }
                            }
                        
                    }, offTap: {
                        if timeItem.isStopwatch {
                            self.timeItem.togglePause()
                        } else {
                            if self.timeItem.remainingTime == 0 {
                                if self.timeItem.isReusable {
                                    self.timeItem.reset()
                                } else {
                                    delete()
                                }
                            } else {
                                self.timeItem.togglePause()
                            }
                        }
                    })
                    Spacer().frame(width:28)
                    
                }.padding(.vertical, 7)
            }
            
        }
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

struct TimerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TimeItemSheet(discard: {}, delete: {})
    }
}
