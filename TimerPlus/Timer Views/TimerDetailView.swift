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
            VStack {
                ScrollView() {
                    VStack(alignment: .leading, spacing: 14) {
                        Text(timer.title ?? "Timer")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("\(timer.timeStarted ?? Date(), formatter: TimerPlus.currentTimeFormatter)")
                        Text("\(timer.createdAt ?? Date(), formatter: TimerPlus.dateFormatter)")
                        Spacer().frame(height: 200)
                        ToggleButton(title: "Notifications", isOn: $timer.isPaused)
                        ToggleButton(title: "Sound", isOn: $timer.isPaused)
                        ToggleButton(title: "Milliseconds", isOn: $timer.isPaused)
                        ToggleButton(title: "Hours", isOn: $timer.isPaused)
                    }.padding(.leading, 28)
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                HStack(spacing: 0) {
                    Spacer().frame(width: 28)
                    MainButton(title: "Stop", isOn: $timer.isPaused, offTitle: "hye", onTitle: "hye")
                    Spacer().frame(width: 28)
                    MainButton(title: "Pause", isOn: $timer.isPaused, offTitle: "hye", onTitle: "hye")
                    Spacer().frame(width: 28)
                }
                .padding(.bottom, 7)
            }
            
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
