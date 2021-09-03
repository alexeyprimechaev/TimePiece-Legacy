//
//  SheetEditors.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 6/20/21.
//  Copyright © 2021 Alexey Primechaev. All rights reserved.
//

import SwiftUI
import AVFoundation

struct DetailEditors: View {
    
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var appState: AppState
    
    @ObservedObject var timeItem: TimeItem
    
    @Binding var titleField: UITextField
    @Binding var timeField: UITextField
    
    @Binding var titleFocused: Bool
    @Binding var timeFocused: Bool
    
    @State var addingComment = false
    
        
    @State var currentTime: String = "00:00"
    
    var body: some View {
        TitleEditor(title: Strings.title, timeItem: timeItem, textField: $titleField, isFocused: $titleFocused)
        
            .onAppear {
                currentTime = timeItem.remainingTimeString
            }
        
        if timeItem.isRunning {
            TimeDisplay(timeItem: timeItem, timeString: $currentTime, isOpaque: true, displayStyle: .labeled, label: Strings.total)
                .onReceive(Clock.precise) { time in
                    currentTime = Clock.updateTime(timeItem: timeItem, currentTime)
                }
        }
        
        if !timeItem.isStopwatch {
                VStack {
                    if timeItem.isRunning == false {
                        TimeEditor(timeString: $timeItem.editableTimeString, textField: $timeField, isFocused: $timeFocused).disabled(timeItem.isRunning)
                    } else {
                        TimeDisplay(timeItem: timeItem, timeString: $timeItem.editableTimeString, isOpaque: true, displayStyle: .labeled, label: Strings.total)
                    }
                }
        }
        
        if timeItem.comment.count > 0 {
            Text(timeItem.comment).lineLimit(timeItem.isRunning ? nil : 3).fontSize(timeItem.isRunning ? .title2 : .comment)
                .padding(7)
                .onTapGesture {
                    addingComment = true
                }.sheet(isPresented: $addingComment) {
                    CommentSheet(comment: $timeItem.comment).environmentObject(settings).environmentObject(appState)
                }
            Divider().padding(7).padding(.bottom, -7)
            
                
        }
    }
    
    
}


public var audioPlayer: AVAudioPlayer?

public func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("ERROR")
        }
    }
}
