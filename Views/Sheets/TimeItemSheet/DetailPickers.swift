//
//  SheetPickers.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 6/20/21.
//  Copyright © 2021 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct DetailPickers: View {
    
    @ObservedObject var timeItem: TimeItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            if timeItem.isStopwatch {
                if timeItem.isReusable {
                    PickerButton(title: Strings.sound, values: TimeItem.soundSettings, controlledValue: $timeItem.soundSetting)
                    PremiumBadge {
                        PickerButton(title: Strings.milliseconds, values: TimeItem.precisionSettings.dropLast(), controlledValue: $timeItem.precisionSetting)
                        
                    }
                    ContinousPicker(value: 0, presetValues: [0, 0.125,0.25,0.50,0.75,1]).transition(.opacity)
                }
            } else {
                if timeItem.isReusable {
                    PickerButton(title: Strings.notification, values: TimeItem.notificationSettings, controlledValue: $timeItem.notificationSetting)
                    if timeItem.notificationSetting == TimeItem.notificationSettings[1] {
                        ContinousPicker(value: 0, presetValues: [0, 0.125,0.25,0.50,0.75,1]).transition(.opacity)
                    }
                    PickerButton(title: Strings.sound, values: TimeItem.soundSettings, controlledValue: $timeItem.soundSetting)
                    PremiumBadge {
                        PickerButton(title: Strings.milliseconds, values: TimeItem.precisionSettings, controlledValue: $timeItem.precisionSetting)
                        
                    }
                }
            }
        }
    }
}


