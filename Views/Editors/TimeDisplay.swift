//
//  TimeDisplay.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 8/29/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

enum TimeDisplayStyle {
    case simple, labeled
}

struct TimeDisplay: View {
    
    @Binding var isPaused: Bool
    @Binding var isRunning: Bool
    @Binding var timeString: String
    
    @State var updateTime: () -> Void
    @State var isOpaque = false
    
    @State var displayStyle: TimeDisplayStyle = .simple
    @State var label: LocalizedStringKey = "Time"
    
    @Binding var precisionSetting: String
    
    @Binding var textField: UITextField
    @Binding var isFocused: Bool
    
    @State private var milliseconds = "00"
    @State private var seconds = ""
    @State private var minutes = ""
    @State private var hours = ""
    
    var body: some View {
        VStack() {
            if isRunning == false && displayStyle == .labeled {
                TimeEditor(timeString: $timeString, textField: $textField, isFocused: $isFocused).disabled(isRunning).animation(nil)
            } else {
                HStack(alignment: .bottom, spacing: 7) {
                    ZStack(alignment: .topLeading) {
                        HStack(spacing: 0) {
                            if hours != "00" {
                                Text(hours).animation(nil)
                                    .opacity(isOpaque ? 1 : 0.5)
                                Dots().opacity(isRunning ? isPaused ? 0.25 : 1 : 0.5).transition(.opacity)
                            }
                            Text(minutes).animation(nil)
                                .opacity(isOpaque ? 1 : 0.5)
                            Dots().opacity(isRunning ? isPaused ? 0.25 : 1 : 0.5).transition(.opacity)
                            Text(seconds).animation(nil)
                                .opacity(isOpaque ? 1 : 0.5)
                            
                            if precisionSetting == TimeItem.precisionSettings[0] || (precisionSetting == TimeItem.precisionSettings[2] && hours == "00" && minutes == "00") {
                                Dots(isMilliseconds: true).opacity(isRunning ? isPaused ? 0.25 : 1 : 0.5).transition(.opacity)
                                Text(milliseconds).animation(nil)
                                    .opacity(isOpaque ? 1 : 0.5)
                            }
                            
                        }
                        
                        HStack(spacing: 0) {
                            if hours != "00" {
                                Text("88").animation(nil)
                                Dots()
                            }
                            Text("88")
                            Dots()
                            Text("88")
                            if precisionSetting == TimeItem.precisionSettings[0] || (precisionSetting == TimeItem.precisionSettings[2] && hours == "00" && minutes == "00") {
                                Dots(isMilliseconds: true).opacity(isRunning ? isPaused ? 0.25 : 1 : 0.5)
                                Text("88").animation(nil)
                                    .opacity(0.5)
                            }
                        }.animation(nil).opacity(0)
                    }
                    if displayStyle == .labeled {
                        Text(label).fontSize(.smallTitle).opacity(0.5).padding(.bottom, 5)
                    }
                }
                
                
                .transition(.opacity)
                .animation(isPaused && isRunning ? Animation.easeOut(duration: 0.5).repeatForever() : Animation.linear, value: isPaused)
                .fontSize(.title)
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
        
        
        
        
    }
    
    
}
