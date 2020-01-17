//
//  TimerPlusDetailView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/6/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI
import Introspect
import CoreData

struct TimerDetailView: View {
    
    @ObservedObject var timer = TimerPlus()
        
    @State var name = ""
    
    var onDismiss: () -> ()
    
    var body: some View {
        
        VStack(spacing:0) {
            HStack() {
                Button(action: {
                    self.onDismiss()
                }) {
                    HStack(alignment: .center) {
                        Image(systemName: "xmark")
                        .font(.system(size: 11.0, weight: .heavy))
                        Text("Dismiss")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(Color.primary)
                }
                .frame(height: 52)
                .padding(.leading, 24)
                .padding(.trailing, 24)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 14) {
                
                PropertyView(title: "Title", timer: timer)

                HStack() {
                    if (timer.totalTime != timer.currentTime) {
                        PropertyView(title: "Left", timer: timer)
                    }
                    PropertyView(title: "Total", timer: timer)
                }
                
                PropertyView(title: "Created at", timer: timer)
            
                ToggleButton(title: "Notifications", values: TimerPlus.notificationSettings, value: $timer.notificationSetting)
                ToggleButton(title: "Sound", values: TimerPlus.soundSettings, value: $timer.soundSetting)
                ToggleButton(title: "Milliseconds", values: TimerPlus.precisionSettings, value: $timer.precisionSetting)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .padding(.leading, 21)
            

        }
    }
}

struct TimerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TimerDetailView(onDismiss: {})
    }
}
