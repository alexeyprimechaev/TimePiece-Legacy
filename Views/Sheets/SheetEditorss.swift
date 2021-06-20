//
//  SheetEditors.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 6/20/21.
//  Copyright © 2021 Alexey Primechaev. All rights reserved.
//

import SwiftUI
import AVFoundation

struct SheetEditorss: View {
    
    @ObservedObject var timeItem: TimeItem
    
    @Binding var titleField: UITextField
    @Binding var timeField: UITextField
    
    @Binding var titleFocused: Bool
    @Binding var timeFocused: Bool
    
        
    @State var currentTime: String = "00:00"
    
    var body: some View {
        TitleEditor(title: Strings.title, timeItem: timeItem, textField: $titleField, isFocused: $titleFocused)
        
            .onAppear {
                currentTime = timeItem.remainingTimeString
            }
        
        if timeItem.isRunning {
            TimeDisplay(isPaused: $timeItem.isPaused, isRunning: $timeItem.isRunning, timeString: $currentTime, updateTime: updateTime, isOpaque: true, displayStyle: .labeled, label: timeItem.isStopwatch ? Strings.total : Strings.left, precisionSetting: $timeItem.precisionSetting, textField: .constant(UITextField()), isFocused: .constant(false))
                .onReceive(Timer.publish(every: 0.015, on: .main, in: .common).autoconnect()) { time in
                    updateTime()
                }
        }
        
        if !timeItem.isStopwatch {
            TimeDisplay(isPaused: $timeItem.isPaused, isRunning: $timeItem.isRunning, timeString: $timeItem.editableTimeString, updateTime: {updateTime()}, isOpaque: true, displayStyle: .labeled, label: Strings.total, precisionSetting: $timeItem.editableTimeString, textField: $timeField, isFocused: $timeFocused)
        }
    }
    
    func updateTime() {
        
        if timeItem.isStopwatch {
            if !timeItem.isPaused {
                currentTime = Date().timeIntervalSince(timeItem.timeStarted).editableStringMilliseconds()
                
            } else {
                
            }
            
            
        } else {
            if !timeItem.isPaused {
                
                
                if timeItem.timeFinished.timeIntervalSince(Date()) <= 0 {
                    
                    timeItem.togglePause()
                    
                    timeItem.remainingTime = 0
                    
                    
                    
                    
                    
                    if timeItem.soundSetting == TimeItem.soundSettings[0] {
                        AudioServicesPlaySystemSound(1007)
                    } else {
                        playSound(sound: "technoFree", type: "wav")
                    }
                    //                    AudioServicesPlaySystemSound(timeItem.soundSetting == TimeItem.soundSettings[0] ? 1007 : 1036)
                    
                    
                    
                    
                    
                }
                
                currentTime = timeItem.timeFinished.timeIntervalSince(Date()).editableStringMilliseconds()
                
                
            }
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
