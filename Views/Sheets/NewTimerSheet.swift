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
        
    var discard: () -> Void
            
    var body: some View {
        VStack(spacing:0) {
            HeaderBar(
            leadingAction: {
                isAdding = false
                discard()
            }, leadingTitle: Strings.discard, leadingIcon: "xmark", leadingIsDestructive: true,
            trailingAction: {
                isAdding = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if !timer.isReusable {
                        print(timer.totalTime)
                        if timer.totalTime > 0 {
                            timer.togglePause()
                        }
                    }
                }
                discard()
            }, trailingTitle: timer.isReusable ? Strings.add : Strings.start, trailingIcon: timer.isReusable ? "plus" : "play")
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 14) {
                                            
                    TitleEditor(title: Strings.title, timer: timer)
                    
                    TimeEditor(timeString: $timer.editableTimeString, becomeFirstResponder: true)
                    
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
        }.onAppear {
            isAdding = false
        }
    }
}

