//
//  TimeDisplay.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 8/29/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

enum TimeDisplayStyle {
    case simple, labeled, small
}

struct TimeDisplay: View {
    
    
    @ObservedObject var timeItem: TimeItem
    @Binding var timeString: String
    
    @State var isOpaque = false
        
    @State var displayStyle: TimeDisplayStyle = .simple
    @State var label: LocalizedStringKey = "Time"
    
    @State private var milliseconds = "00"
    @State private var seconds = ""
    @State private var minutes = ""
    @State private var hours = ""


    
    var body: some View {
                HStack(alignment: .bottom, spacing: 7) {
                    ZStack(alignment: .topLeading) {
                        HStack(spacing: 0) {
                            if hours != "00" {
                                Text(Int(hours) ?? 0 > 9 ? hours : String(hours.suffix(1))).animation(nil)
                                    .opacity(isOpaque ? 1 : 0.5)
                                Dots(isSmall: displayStyle == .small ? true : false).opacity(timeItem.isRunning ? timeItem.isPaused ? 0.25 : 1 : 0.5).transition(.opacity)
                            }
                            Text(Int(hours) ?? 0 > 0 || Int(minutes) ?? 0 > 9 ? minutes : String(minutes.suffix(1))).animation(nil)
                                .opacity(isOpaque ? 1 : 0.5)
                            Dots(isSmall: displayStyle == .small ? true : false).opacity(timeItem.isRunning ? timeItem.isPaused ? 0.25 : 1 : 0.5).transition(.opacity)
                            Text(seconds).animation(nil)
                                .opacity(isOpaque ? 1 : 0.5)
                            
                            if timeItem.precisionSetting == TimeItem.precisionSettings[1] || (timeItem.precisionSetting == TimeItem.precisionSettings[2] && hours == "00" && minutes == "00") {
                                Dots(isMilliseconds: true, isSmall: displayStyle == .small ? true : false).opacity(timeItem.isRunning ? timeItem.isPaused ? 0.25 : 1 : 0.5).transition(.opacity)
                                Text(milliseconds).animation(nil)
                                    .opacity(isOpaque ? 1 : 0.5)
                            }
                            
                        }
                        
                    }
                    if displayStyle == .labeled {
                        Text(label).fontSize(.smallTitle).opacity(0.5).padding(.bottom, 5)
                    }
                }
                
                
                .transition(.opacity)
                .animation(timeItem.isPaused && timeItem.isRunning ? Animation.easeOut(duration: 0.5).repeatForever() : Animation.linear, value: timeItem.isPaused)
                .fontSize(displayStyle == .small ? .smallTitle : .title)
                .animation(nil)
                .fixedSize()
                .onChange(of: timeString) { newValue in
                    if timeString.count == 8 {
                        hours = String(timeString.prefix(2))
                        minutes = String(timeString.prefix(4).suffix(2))
                        seconds = String(timeString.suffix(4).prefix(2))
                        milliseconds = String(timeString.suffix(2))
                    } else {
                        hours = String(timeString.prefix(2))
                        minutes = String(timeString.prefix(4).suffix(2))
                        seconds = String(timeString.suffix(2))
                    }
                }
                .onAppear {
                    if timeString.count == 8 {
                        hours = String(timeString.prefix(2))
                        minutes = String(timeString.prefix(4).suffix(2))
                        seconds = String(timeString.suffix(4).prefix(2))
                        milliseconds = String(timeString.suffix(2))
                    } else {
                        hours = String(timeString.prefix(2))
                        minutes = String(timeString.prefix(4).suffix(2))
                        seconds = String(timeString.suffix(2))
                    }
                    
                }
                .padding(displayStyle == .labeled ? 7 : 0)
            
        
        
        
        
        
    }
    
    
}
