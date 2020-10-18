//
//  NewTimerView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/20/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct NewTimeItemSheet: View {
    
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var timer = TimeItem()
    
    @Binding var isAdding: Bool
    
    @State var showingOptions = false
    
    @State var titleField = UITextField()
    @State var timeField = UITextField()
    
    @State var titleFocused = false
    @State var timeFocused = false
        
    var discard: () -> Void
            
    var body: some View {
        VStack(spacing:0) {
            HeaderBar(
            leadingAction: {
                isAdding = false
                discard()
            }, leadingTitle: Strings.discard, leadingIcon: "xmark", leadingIsDestructive: true,
            trailingAction: {})
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 14) {
                                            
                    TitleEditor(title: Strings.title, timer: timer, textField: $titleField, isFocused: $titleFocused)
                    
                    if !timer.isStopwatch {
                        TimeEditor(timeString: $timer.editableTimeString, becomeFirstResponder: true, textField: $timeField, isFocused: $timeFocused)
                    }
                    
                    VStack(alignment: .leading, spacing: 14) {
                        
                        
                        if !timer.isStopwatch {
                            PremiumBadge {
                                PickerButton(title: Strings.reusable, values: [true.yesNo, false.yesNo], controlledValue: $timer.isReusable.yesNo)
                            }
                        }
                        
                        
                        VStack(alignment: .leading, spacing: 7) {
                            if !timer.isStopwatch {
                                
                                RegularButton(title: "Convert to Stopwatch", icon: "stopwatch") {
                                    self.timer.isStopwatch = true
                                    titleField.becomeFirstResponder()
                                }
                                
                            } else {
                                RegularButton(title: "Convert to Timer", icon: "timer") {
                                    self.timer.isStopwatch = false
                                    timeField.becomeFirstResponder()
                                }
                            }
                            
                            RegularButton(title: showingOptions ? "Less Options" : "More Options", icon: "ellipsis.circle") {
                                showingOptions.toggle()
                            }.opacity(showingOptions ? 0.5 : 1)
                        }
                    
                        if showingOptions {
                            
                            if !timer.isStopwatch {
                                PickerButton(title: Strings.notification, values: TimeItem.notificationSettings, controlledValue: $timer.notificationSetting)
                                
                                PremiumBadge {
                                    PickerButton(title: Strings.sound, values: TimeItem.soundSettings, controlledValue: $timer.soundSetting)
                                }
                            }
                            
                           
                            PremiumBadge {
                                PickerButton(title: Strings.milliseconds, values: TimeItem.precisionSettings, controlledValue: $timer.precisionSetting)
                            }
                            PremiumBadge {
                                PickerButton(title: Strings.showInLog, values: [true.yesNo, false.yesNo], controlledValue: $timer.showInLog.yesNo)
                            }
                        }
                            
                        }.animation(.default, value: showingOptions)
                    

                    
                    
                }.padding(.leading, 21).animation(.default, value: timer.isStopwatch)
            }
                EditorBar(titleField: $titleField, timeField: $timeField, titleFocused: $titleFocused, timeFocused: $timeFocused, showSwitcher: $timer.isStopwatch) {
                    if !timer.isStopwatch {
                        Button {
                            isAdding = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                if !timer.isReusable {
                                    if timer.totalTime > 0 {
                                        timer.togglePause()
                                    }
                                }
                            }
                            discard()
                        } label: {
                            Label {
                                Text(timer.isReusable ? Strings.add : Strings.start).fontSize(.smallTitle)
                            } icon: {
                                Image(systemName: timer.isReusable ? "plus" : "play").font(.headline)
                            }.padding(.horizontal, 14).padding(.vertical, 7).background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                                    .foregroundColor(Color("button.gray"))).padding(.vertical, 7)
                        }
                    } else {
                        

                        Button {
                            self.timer.editableTimeString = "000000"
                            isAdding = true
                            discard()
                        } label: {
                            Label {
                                Text(Strings.add).fontSize(.smallTitle)
                            } icon: {
                                Image(systemName: "plus").font(.headline)
                            }.padding(.horizontal, 14).padding(.vertical, 7).background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                                    .foregroundColor(Color("button.gray"))).padding(.vertical, 7)
                        }
                        Spacer()
                        
                        Button {
                            self.timer.editableTimeString = "000000"
                            isAdding = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                timer.togglePause()
                            }
                            discard()
                        } label: {
                            Label {
                                Text(Strings.start).fontSize(.smallTitle)
                            } icon: {
                                Image(systemName: "play").font(.headline)
                            }.padding(.horizontal, 14).padding(.vertical, 7).background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                                    .foregroundColor(Color("button.gray"))).padding(.vertical, 7)
                        }
                    }
                    
                }
            

        }.onAppear {
            isAdding = false
        }
    }
}

