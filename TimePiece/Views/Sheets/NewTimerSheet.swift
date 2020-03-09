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
            HStack() {
                Button(action: {
                    self.isAdding = false
                    self.discard()
                }) {
                    HStack(alignment: .center) {
                        Image(systemName: "xmark")
                            .font(.system(size: 11.0, weight: .heavy))
                            .smallTitleStyle()
                            
                        Text("Discard")
                            .smallTitleStyle()
                    }
                    .padding(.leading, 28)
                    .padding(.trailing, 64)
                    .foregroundColor(Color.red)
                }
                .frame(height: 52)
                Spacer()
                Button(action: {
                    self.isAdding = true
                    self.discard()
                }) {
                    HStack(alignment: .center) {
                        Image(systemName: "plus")
                            .font(.system(size: 11.0, weight: .heavy))
                        Text("Add")
                            .fontWeight(.semibold)
                    }
                    .padding(.leading, 64)
                    .padding(.trailing, 28)
                    .foregroundColor(Color.primary)
                }
                .frame(height: 52)
            }
            
            ScrollView() {
                
                VStack(alignment: .leading, spacing: 14) {
                                            
                    PropertyView(title: "Title", timer: self.timer )
                    
                    EditableTimeView(time: $timer.totalTime, title: "Time", isFirstResponder: true, update: {
                        self.timer.currentTimeStored = self.timer.totalTimeStored
                    })
                    
                    ToggleButton(title: "Reusable", trueTitle: "Yes", falseTitle: "No", value: $timer.isReusable)
                    
                    VStack(alignment: .leading, spacing: 14) {
                        
                        ToggleButton(title: "Options", trueTitle: "", falseTitle: "", value: $showingOptions)
                    
                    
                    if showingOptions {
                        PickerButton(title: "Notifications", values: TimerPlus.notificationSettings, value: $timer.notificationSetting)
                        PickerButton(title: "Sound", values: TimerPlus.soundSettings, value: $timer.soundSetting)
                        PickerButton(title: "Milliseconds", values: TimerPlus.precisionSettings, value: $timer.precisionSetting)
                    }
                    }.animation(.default, value: showingOptions)
                    

                    
                    
                }.padding(.leading, 21)
            }
        }.onAppear() {
            self.isAdding = false
        }
    }
}

