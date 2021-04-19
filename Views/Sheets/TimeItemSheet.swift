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
    
    @State var showingMakeReusableAlert = false
    
    @State var showingConvertAlert = false
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var discard: () -> Void
    
    var delete: () -> Void
    
    var body: some View {
        
        
        VStack(spacing:0) {
            
            HeaderBar {
                RegularButton(title: Strings.dismiss, icon: "chevron.down") {
                    discard()
                }
            } trailingItems: {
                RegularButton(title: Strings.delete, icon: "trash") {
                    delete()
                }
            }
            
//
//            HeaderBar(leadingAction: discard,
//                      leadingTitle: Strings.dismiss,
//                      leadingIcon: horizontalSizeClass == .compact ? "chevron.down" : "chevron.left",
//                      leadingIsDestructive: false,
//                      trailingAction: {delete()}, trailingTitle: "Delete")
            TitledScrollView {
                
                VStack(alignment: .leading, spacing: 14) {
                    
                    TitleEditor(title: Strings.title, timeItem: timeItem, textField: $titleField, isFocused: $titleFocused).disabled(!timeItem.isPaused)
                    
                    if timeItem.isRunning {
                        TimeDisplay(isPaused: $timeItem.isPaused, isRunning: $timeItem.isRunning, timeString: $currentTime, updateTime: updateTime, isOpaque: true, displayStyle: .labeled, label: timeItem.isStopwatch ? Strings.total : Strings.left, precisionSetting: $timeItem.precisionSetting, textField: $timeFieldDummy, isFocused: $timeFocusedDummy)
                    }
                    
                    if timeItem.isStopwatch {
                        if timeItem.isReusable {
                            PickerButton(title: Strings.notification, values: TimeItem.notificationSettings, controlledValue: $timeItem.notificationSetting)
                            PickerButton(title: Strings.sound, values: TimeItem.soundSettings, controlledValue: $timeItem.soundSetting)
                            PremiumBadge {
                                PickerButton(title: Strings.milliseconds, values: TimeItem.precisionSettings.dropLast(), controlledValue: $timeItem.precisionSetting)
                                
                            }
                            
                            PremiumBadge {
                                PickerButton(title: Strings.showInLog, values: [false.yesNo, true.yesNo], controlledValue: $timeItem.showInLog.yesNo)
                            }
                            PremiumBadge {
                                RegularButton(title: "Convert to Timer", icon: "timer") {
                                    if timeItem.isRunning {
                                        showingConvertAlert = true
                                    } else {
                                        timeItem.isStopwatch = false
                                    }
                                }
                            }
                        } else {
                            VStack(alignment: .leading, spacing: 7) {
                                PremiumBadge {
                                    RegularButton(title: Strings.makeReusable, icon: "arrow.clockwise") {
                                        timeItem.makeReusable()
                                    }
                                }
                                PremiumBadge {
                                    RegularButton(title: "Convert to Timer", icon: "timer") {
                                        if timeItem.isRunning {
                                            showingConvertAlert = true
                                        } else {
                                            timeItem.isStopwatch = false
                                        }
                                    }
                                }
                            }
                            
                            
                        }
                        
                    } else {
                        TimeDisplay(isPaused: $timeItem.isPaused, isRunning: $timeItem.isRunning, timeString: $timeItem.editableTimeString, updateTime: {updateTime()}, isOpaque: true, displayStyle: .labeled, label: Strings.total, precisionSetting: $timeItem.editableTimeString, textField: $timeField, isFocused: $timeFocused)
                        
                        if timeItem.isReusable {
                            PickerButton(title: Strings.notification, values: TimeItem.notificationSettings, controlledValue: $timeItem.notificationSetting)
                            PickerButton(title: Strings.sound, values: TimeItem.soundSettings, controlledValue: $timeItem.soundSetting)
                            PremiumBadge {
                                PickerButton(title: Strings.milliseconds, values: TimeItem.precisionSettings, controlledValue: $timeItem.precisionSetting)
                                
                            }
                            
                            PremiumBadge {
                                PickerButton(title: Strings.showInLog, values: [false.yesNo, true.yesNo], controlledValue: $timeItem.showInLog.yesNo)
                            }
                            
                            PremiumBadge {
                                RegularButton(title: "Convert to Stopwatch", icon: "stopwatch") {
                                    if timeItem.isRunning {
                                        showingConvertAlert = true
                                    } else {
                                        withAnimation {
                                            timeItem.convertToStopwatch()
                                        }
                                    }
                                    
                                }
                            }
                            
                        } else {
                            
                            VStack(alignment: .leading, spacing: 7) {
                                PremiumBadge {
                                    RegularButton(title: Strings.makeReusable, icon: "arrow.clockwise") {
                                        timeItem.makeReusable()
                                    }
                                }
                                
                                PremiumBadge {
                                    RegularButton(title: "Convert to Stopwatch", icon: "stopwatch") {
                                        if timeItem.isRunning {
                                            showingConvertAlert = true
                                        } else {
                                            withAnimation {
                                                timeItem.convertToStopwatch()
                                            }
                                        }
                                        
                                    }
                                }
                            }
                            
                        }
                        
                        
                        
                        
                    }
                    
                    
                }
                .alert(isPresented: $showingConvertAlert) {
                    if timeItem.isStopwatch {
                        return Alert(title: Text("Convert to Timer?"), message: Text("Converting will reset the Stopwatch"), primaryButton: .default(Text("Convert"), action:  {
                            timeItem.reset()
                            timeItem.isStopwatch = false
                        }), secondaryButton: .cancel())
                    } else {
                        return Alert(title: Text("Convert to Stopwatch?"), message: Text("Converting will reset the Timer"), primaryButton: .default(Text("Convert"), action:  {
                            timeItem.reset()
                            timeItem.convertToStopwatch()
                        }), secondaryButton: .cancel())
                    }
                }
                .onAppear {
                    currentTime = timeItem.remainingTimeString
                }
                .onAppear {
                    print("isSubscribed")
                    print(settings.isSubscribed)
                }
                .onReceive(Timer.publish(every: 0.015, on: .main, in: .common).autoconnect()) { time in
                    updateTime()
                }
                
            }
            .animation(.default)
            
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
                HStack(spacing: 0) {
                    Spacer().frame(width:28)
                    if timeItem.isRunning {
                        if timeItem.isReusable {
                            PauseButton(color: Color.red, isPaused: $timeItem.isRunning, offTitle: timeItem.remainingTime == 0 ? Strings.reset : Strings.reset, onTitle: Strings.reset, offIcon: "stop.fill", onIcon: "stop.fill",
                                        onTap: {
                                            timeItem.reset()
                                        },
                                        offTap: {
                                            timeItem.reset()
                                        }
                            )
                            .disabled(timeItem.isRunning ? false : true)
                        } else {
                            PauseButton(color: Color.red, isPaused: $timeItem.isRunning, offTitle: timeItem.remainingTime == 0 ? Strings.reset : Strings.reset, onTitle: Strings.reset, offIcon: "stop.fill", onIcon: "stop.fill",
                                        onTap: {
                                            showingMakeReusableAlert = true
                                        },
                                        offTap: {
                                            showingMakeReusableAlert = true
                                        }
                            )
                            .disabled(timeItem.isRunning ? false : true)
                            .alert(isPresented: $showingMakeReusableAlert) {
                                Alert(title: Text("You can only reset Reusable Timers"), primaryButton: .default(Text("Make Reusable")) {
                                    
                                    withAnimation {
                                        
                                        if settings.isSubscribed {
                                            timeItem.makeReusable()
                                        } else {
                                            settings.showingSubscription = true
                                        }
                                    }
                                    
                                }, secondaryButton: .cancel())
                            }
                            
                            .fullScreenCover(isPresented: $settings.showingSubscription) {
                                SubscriptionSheet {
                                    settings.showingSubscription = false
                                }.environmentObject(settings)
                            }
                        }
                        Spacer().frame(width:14)
                    }
                    
                    PauseButton(color: Color.primary, isPaused: $timeItem.isPaused, offTitle: timeItem.isRunning ? "Start" : timeItem.isStopwatch ? "Start Stopwatch" : "Start Timer", onTitle: Strings.pause, offIcon: "play.fill", onIcon: "pause.fill", onTap: {
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
                    
                }.padding(.vertical, 7).padding(.bottom, 7).animation(.default, value: timeItem.isRunning)
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
