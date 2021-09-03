//
//  UpdateTime.swift
//  UpdateTime
//
//  Created by Alexey Primechaev on 9/4/21.
//  Copyright © 2021 Alexey Primechaev. All rights reserved.
//

import Foundation
import AVFoundation

struct ClockUI {
    
    static func updateTime(timeItem: TimeItem, _ currentTimeOld: String) -> String {
        
        var currentTime = currentTimeOld
        
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
        
        return currentTime
        
    }
}
