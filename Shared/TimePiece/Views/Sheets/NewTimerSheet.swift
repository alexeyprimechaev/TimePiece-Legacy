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
        
    var discard: () -> ()
            
    var body: some View {
        VStack(spacing:0) {
            HeaderBar(
            leadingAction: {
                self.isAdding = false
                self.discard()
            }, leadingTitle: discardString, leadingIcon: "xmark", leadingIsDestructive: true,
            trailingAction: {
                self.isAdding = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if !self.timer.isReusable {
                        print(self.timer.totalTime)
                        if self.timer.totalTime > 0 {
                            self.timer.togglePause()
                        }
                    }
                }
                self.discard()
            }, trailingTitle: self.timer.isReusable ? addString : startString, trailingIcon: self.timer.isReusable ? "plus" : "play")
            
            ScrollView() {
                
                VStack(alignment: .leading, spacing: 14) {
                                            
                    PropertyView(title: titleString, timer: self.timer )
                    
                    EditableTimeView(time: $timer.totalTime, title: timeString, isFirstResponder: true, update: {
                        self.timer.currentTime = self.timer.totalTime
                    })
                    VStack(alignment: .leading, spacing: 14) {
                        
                        PremiumBadge() {
                            PickerButton(title: reusableString, values: [true.yesNo, false.yesNo], value: self.$timer.isReusable.yesNo)
                        }
                        
                        if !showingOptions {
                            Button(action: {
                                lightHaptic()
                                self.showingOptions.toggle()
                            }) {
                                Label("More Options", systemImage: "ellipsis.circle")
                                .smallTitle()
                                .padding(.horizontal, 7)
                                .padding(.vertical, 14)
                                .foregroundColor(.primary)
                                
                            }
                        }
                    
                        if showingOptions {
                            
                            PickerButton(title: notificationString, values: TimerItem.notificationSettings, value: $timer.notificationSetting)
                            
                            PremiumBadge() {
                                PickerButton(title: soundString, values: TimerItem.soundSettings, value: self.$timer.soundSetting)
                            }
                            PremiumBadge() {
                                PickerButton(title: millisecondsString, values: TimerItem.precisionSettings, value: self.$timer.precisionSetting)
                            }
                            PremiumBadge() {
                                PickerButton(title: showInLogString, values: [true.yesNo, false.yesNo], value: self.$timer.showInLog.yesNo)
                            }
                        }
                            
                        }.animation(.default, value: showingOptions)
                    

                    
                    
                }.padding(.leading, 21)
            }
        }.onAppear() {
            self.isAdding = false
        }
    }
}

