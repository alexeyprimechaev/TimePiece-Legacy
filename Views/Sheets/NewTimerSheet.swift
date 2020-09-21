//
//  NewTimerView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/20/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct NewTimerSheet: View {
    
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var timer = TimerItem()
    
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
                    
                    TimeEditor(timeString: $timer.editableTimeString, becomeFirstResponder: true, textField: $timeField, isFocused: $timeFocused)
                    
                    VStack(alignment: .leading, spacing: 14) {
                        
                        PremiumBadge {
                            PickerButton(title: Strings.reusable, values: [true.yesNo, false.yesNo], controlledValue: $timer.isReusable.yesNo)
                        }
                        
                        if !showingOptions {
                            Button(action: {
                                lightHaptic()
                                showingOptions.toggle()
                            }) {
                                Label {
                                    Text("More Options").fontSize(.smallTitle)
                                } icon: {
                                    Image(systemName: "ellipsis.circle").font(.headline)
                                }
                                .padding(.horizontal, 7)
                                .padding(.vertical, 14)
                                .foregroundColor(.primary)
                                
                            }
                        }
                    
                        if showingOptions {
                            
                            PickerButton(title: Strings.notification, values: TimerItem.notificationSettings, controlledValue: $timer.notificationSetting)
                            
                            PremiumBadge {
                                PickerButton(title: Strings.sound, values: TimerItem.soundSettings, controlledValue: $timer.soundSetting)
                            }
                            PremiumBadge {
                                PickerButton(title: Strings.milliseconds, values: TimerItem.precisionSettings, controlledValue: $timer.precisionSetting)
                            }
                            PremiumBadge {
                                PickerButton(title: Strings.showInLog, values: [true.yesNo, false.yesNo], controlledValue: $timer.showInLog.yesNo)
                            }
                        }
                            
                        }.animation(.default, value: showingOptions)
                    

                    
                    
                }.padding(.leading, 21)
            }
            
            EditorBar(titleField: $titleField, timeField: $timeField, titleFocused: $titleFocused, timeFocused: $timeFocused) {
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
            }
        }.onAppear {
            isAdding = false
        }
    }
}

