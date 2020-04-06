//
//  SettingsSheet.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 3/5/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct SettingsSheet: View {
    
    @EnvironmentObject var settings: Settings
                        
    var discard: () -> ()
            
    var body: some View {
        VStack(alignment: .leading, spacing:0) {
            HeaderBar(leadingAction: { self.discard() }, leadingTitle: "Dismiss", leadingIcon: "xmark", trailingAction: {})
            
            ScrollView() {
                
                VStack(alignment: .leading, spacing: 14) {
                    
                    Text("Settings").title().padding(7)
                    
                    ListSection(title: "Made in Moscow with ❤️ by") {
                        PersonCard(name: "Alexey Primechaev", description: "Creator, Designer, Developer", link: "https://twitter.com/numberl6", image: "alesha", icon: "twitter")
                        PersonCard(name: "Igor Dyachuk", description: "Designer", link: "https://twitter.com/stopuikit", image: "igor", icon: "twitter")
                    }
                    
                    ListSection(title: "New Timers") {
                        PickerButton(title: "Notifications", values: TimerItem.notificationSettings, value: self.$settings.notificationSettingDefault)
                        PremiumBadge() {
                            PickerButton(title: "Sound", values: TimerItem.soundSettings, value: self.$settings.soundSettingDefault)
                        }
                        PremiumBadge() {
                            PickerButton(title: "Milliseconds", values: TimerItem.precisionSettings, value: self.$settings.precisionSettingDefault)
                        }
                            
                        PremiumBadge() {
                            PickerButton(title: "Reusable", values: TimerItem.reusableSettings, value: self.$settings.isReusableDefault)
                        }
                        
                    }
                    
                    ListSection(title: "Visuals") {
                        PremiumBadge() {
                            PickerButton(title: "Font", values: [Font.Design.default.string, Font.Design.rounded.string], value: self.$settings.fontDesign.string)
                        }
                        PremiumBadge() {
                            PickerButton(title: "Monochrome", values: [true.stringValue, false.stringValue], value: self.$settings.isMonochrome.stringValue)
                        }
                        
                        //ToggleButton(title: "Subscription", trueTitle: "Off", falseTitle: "On", value: self.$settings.isSubscribed)
                        
                    }
                    
                    
                }.padding(.leading, 21).padding(.bottom, 28).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                    
                }
        }
        
    }
}
