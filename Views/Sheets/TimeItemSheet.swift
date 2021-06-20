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
import AVFoundation

public var audioPlayer: AVAudioPlayer?

public func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("ERROR")
        }
    }
}

struct TimeItemSheet: View {
    
    
    @ObservedObject var timeItem = TimeItem()
    
    @EnvironmentObject var settings: Settings
    
    @State var name = ""
    
    @State var currentTime: String = "00:00"
    @State var totalTime: String = "000000"
    
    @State var picking: String = "Off"
    
    @State var addingComment = false
    @State var showSettings = false
    
    @State var titleField = UITextField()
    @State var timeField = UITextField()
    
    
    
    @State var titleFocused = false
    @State var timeFocused = false
    
    @State var showLogSheet = false
    
    @State var timeFieldDummy = UITextField()
    @State var timeFocusedDummy = false
    
    @State var showingMakeReusableAlert = false
    
    @State var showingConvertAlert = false
    
    @State var addedTime: TimeInterval = 0
    
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
                RegularButton(title: Strings.delete, icon: "trash", isDestructive: true) {
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
                    
                    TitleEditor(title: Strings.title, timeItem: timeItem, textField: $titleField, isFocused: $titleFocused)
                    
                    if timeItem.isRunning {
                        TimeDisplay(isPaused: $timeItem.isPaused, isRunning: $timeItem.isRunning, timeString: $currentTime, updateTime: updateTime, isOpaque: true, displayStyle: .labeled, label: timeItem.isStopwatch ? Strings.total : Strings.left, precisionSetting: $timeItem.precisionSetting, textField: $timeFieldDummy, isFocused: $timeFocusedDummy)
                    }
                    
                    if timeItem.isStopwatch {
                        if timeItem.isRunning {
                            RegularButton(title: "Show Settings", icon: "ellipsis") {
                                showSettings.toggle()
                            }.opacity(showSettings ? 0.5 : 1)
                        }
                        
                        if !timeItem.isRunning || showSettings {
                            if timeItem.isReusable {
                            PickerButton(title: Strings.sound, values: TimeItem.soundSettings, controlledValue: $timeItem.soundSetting)
                            PremiumBadge {
                                PickerButton(title: Strings.milliseconds, values: TimeItem.precisionSettings.dropLast(), controlledValue: $timeItem.precisionSetting)
                                
                            }
                            

                            
                            ContinousPicker(value: 0.25, presetValues: [0, 0.125,0.25,0.50,0.75,1])
                            
                            
                            
                            
                            
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
                        }
                        
                        if timeItem.isReusable {
                            PremiumBadge {
                                RegularButton(title: "Convert to Timer", icon: "timer") {
                                    if timeItem.isRunning {
                                        showingConvertAlert = true
                                    } else {
                                        timeItem.isStopwatch = false
                                    }
                                }
                            }
                            PremiumBadge {
                                RegularButton(title: "Show in Log", icon: "gobackward") {
                                    showLogSheet = true
                                }
                            }
                            
                            if timeItem.comment == "" {
                                
                            }
                            
                            if !addingComment {
                            PremiumBadge {
                                RegularButton(title: "Add Comment", icon: "plus.bubble") {
                                    addingComment = true
                                }
                            }
                            } else {
                                TextEditor(text: $timeItem.comment).fontSize(.secondaryText)
                            }
                        }
                        
                    } else {
                        TimeDisplay(isPaused: $timeItem.isPaused, isRunning: $timeItem.isRunning, timeString: $timeItem.editableTimeString, updateTime: {updateTime()}, isOpaque: true, displayStyle: .labeled, label: Strings.total, precisionSetting: $timeItem.editableTimeString, textField: $timeField, isFocused: $timeFocused)
                        
                        if timeItem.isReusable {
                            PickerButton(title: Strings.notification, values: TimeItem.notificationSettings, controlledValue: $timeItem.notificationSetting)
                            if timeItem.notificationSetting == TimeItem.notificationSettings[1] {
                                ContinousPicker(value: 0.25, presetValues: [0, 0.125,0.25,0.50,0.75,1])
                            }
                            PickerButton(title: Strings.sound, values: TimeItem.soundSettings, controlledValue: $timeItem.soundSetting)
                            PremiumBadge {
                                PickerButton(title: Strings.milliseconds, values: TimeItem.precisionSettings, controlledValue: $timeItem.precisionSetting)
                                
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
                            
                            if timeItem.isRunning {
                                
                                PremiumBadge {
                                    Menu {
                                        RegularButton(title: "1 minute", icon: "") {
                                            timeItem.addTime(time: 60)
                                        }
                                        
                                        RegularButton(title: "5 minutes", icon: "") {
                                            timeItem.addTime(time: 300)
                                        }
                                        RegularButton(title: "10 minutes", icon: "") {
                                            timeItem.addTime(time: 600)
                                        }
                                    } label: {
                                        RegularButton(title: "Add Time...", icon: "plus.circle") {
                                            
                                        }
                                    }
                                }
                            } else {
                                RegularButton(title: "Show in Log", icon: "gobackward") {
                                    showLogSheet = true
                                }
                                if !addingComment {
                                PremiumBadge {
                                    RegularButton(title: "Add Comment", icon: "plus.bubble") {
                                        addingComment = true
                                    }
                                }
                                } else {
                                    TextEditor(text: $timeItem.comment).fontSize(.secondaryText)
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
                                
                                
                                if timeItem.isRunning {
                                    
                                    PremiumBadge {
                                        Menu {
                                            RegularButton(title: "1 minute", icon: "") {
                                                addedTime += 60
                                                timeItem.addTime(time: 60)
                                            }
                                            
                                            RegularButton(title: "5 minutes", icon: "") {
                                                addedTime += 300
                                                timeItem.addTime(time: 300)
                                            }
                                            RegularButton(title: "10 minutes", icon: "") {
                                                addedTime += 60
                                                timeItem.addTime(time: 600)
                                            }
                                        } label: {
                                            RegularButton(title: "Add Time...", icon: "plus.circle") {
                                                
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                        
                        
                        
                        
                    }
                    
                    
                }
                .padding(.top, 14)
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
                    totalTime = timeItem.editableTimeString
                }
                .onAppear {
                    print("isSubscribed")
                    print(settings.isSubscribed)
                }
                .onReceive(Timer.publish(every: 0.015, on: .main, in: .common).autoconnect()) { time in
                    updateTime()
                }
                
                .sheet(isPresented: $showLogSheet) {
                    LogSheet(title: timeItem.title, discard: {showLogSheet = false})
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
                    
                    
                    
                    
                    
                    if timeItem.soundSetting == TimeItem.soundSettings[0] {
                        AudioServicesPlaySystemSound(1007)
                    } else {
                        playSound(sound: "technoFree", type: "wav")
                    }
//                    AudioServicesPlaySystemSound(timeItem.soundSetting == TimeItem.soundSettings[0] ? 1007 : 1036)
                    
                    
                    
                    
                    
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
