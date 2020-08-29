//
//  TimeDisplay.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 8/29/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct TimeDisplay: View {
    
    @Binding var isPaused: Bool
    @Binding var isRunning: Bool
    @Binding var timeString: String
    
    @State var updateTime: () -> ()
    
    @State private var seconds = ""
    @State private var minutes = ""
    @State private var hours = ""
    
    var body: some View {
        
        HStack(spacing: 0) {
            if hours != "00" {
                Text(hours).animation(nil)
                    .opacity(0.5)
                Dots().opacity(isRunning ? isPaused ? 0.25 : 1 : 0.5)
            }
            Text(minutes).animation(nil)
                .opacity(0.5)
            Dots().opacity(isRunning ? isPaused ? 0.25 : 1 : 0.5)
            Text(seconds).animation(nil)
                .opacity(0.5)
//            Dots(isMilliseconds: true).opacity(isRunning ? isPaused ? 0.25 : 1 : 0.5)
//            Text(seconds).animation(nil)
//                .opacity(0.5)
        }
        .frame(width: hours == "00" ? 100 : 300, alignment: .topLeading)
        .background(Color.red)
        
        .transition(.opacity)
        .animation(isPaused && isRunning ? Animation.easeOut(duration: 0.5).repeatForever() : Animation.linear, value: isPaused)
        .title()
        .fixedSize()
        .onChange(of: timeString) { newValue in
            hours = String(timeString.prefix(2))
            minutes = String(timeString.prefix(4).suffix(2))
            seconds = String(timeString.suffix(2))
        }
        .onAppear() {
            hours = String(timeString.prefix(2))
            minutes = String(timeString.prefix(4).suffix(2))
            seconds = String(timeString.suffix(2))
        }
    }
    
    
}
