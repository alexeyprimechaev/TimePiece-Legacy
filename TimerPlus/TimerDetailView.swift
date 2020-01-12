//
//  TimerPlusDetailView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/6/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct TimerDetailView: View {
    
    @ObservedObject var timer = TimerPlus()
    
    var onDismiss: () -> ()
    
    var body: some View {
        
        NavigationView() {
            ScrollView() {
                VStack(alignment: .leading, spacing: 14) {
                    Text(timer.title ?? "Timer")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("\(timer.timeStarted ?? Date(), formatter: TimerPlus.timeFormatter)")
                    Text("\(timer.createdAt ?? Date(), formatter: TimerPlus.dateFormatter)")
                    ToggleButton(title: "Notifications", isOn: $timer.isPaused)
                    ToggleButton(title: "Sound", isOn: $timer.isPaused)
                    ToggleButton(title: "Milliseconds", isOn: $timer.isPaused)
                    ToggleButton(title: "Hours", isOn: $timer.isPaused)
                }
            }
            .padding(.leading, 28)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: Alignment.topLeading)
            .navigationBarItems(leading: Button(action: {
                    self.onDismiss()
                }, label: {
                    HStack(alignment: .center) {
                        Image(systemName: "xmark")
                        .font(.system(size: 11.0, weight: .heavy))
                        Text("Dismiss")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(Color.primary)
                    
                }))
        }
    }
}

struct TimerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TimerDetailView(onDismiss: {})
    }
}
