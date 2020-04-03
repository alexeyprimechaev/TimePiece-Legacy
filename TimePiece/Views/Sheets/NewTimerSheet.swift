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
    
    @ObservedObject var timer = TimerPlus()
    
    @Binding var isAdding: Bool
    
    @State var showingOptions = false
        
    var discard: () -> ()
            
    var body: some View {
        VStack(spacing:0) {
            HeaderBar(
            leadingAction: {
                self.isAdding = false
                self.discard()
            }, leadingTitle: "Discard", leadingIcon: "xmark", leadingIsDestructive: true,
            trailingAction: {
                self.isAdding = true
                self.discard()
            }, trailingTitle: "Add", trailingIcon: "plus")
            
            ScrollView() {
                
                VStack(alignment: .leading, spacing: 14) {
                                            
                    PropertyView(title: "Title", timer: self.timer )
                    
                    EditableTimeView(time: $timer.totalTime, title: "Time", isFirstResponder: true, update: {
                        self.timer.currentTimeStored = self.timer.totalTimeStored
                    })
                    VStack(alignment: .leading, spacing: 14) {
                        
                        ToggleButton(title: "Options", trueTitle: "", falseTitle: "", value: $showingOptions)
                    
                    
                    if showingOptions {   
                        
                        PickerButton(title: "Notifications", values: TimerPlus.notificationSettings, value: $timer.notificationSetting)
                        PremiumBadge() {
                            PickerButton(title: "Sound", values: TimerPlus.soundSettings, value: self.$timer.soundSetting)
                        }
                        PremiumBadge() {
                            PickerButton(title: "Milliseconds", values: TimerPlus.precisionSettings, value: self.$timer.precisionSetting)
                        }
                        PremiumBadge() {
                            ToggleButton(title: "Reusable", trueTitle: "Yes", falseTitle: "No", value: self.$timer.isReusable)
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

