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
            HeaderBar(leadingAction: { self.discard() }, leadingTitle: dismissString, leadingIcon: "chevron.down", trailingAction: {})
            
            ScrollView() {
                
                VStack(alignment: .leading, spacing: 14) {
                    
                    Text(settingsString).fontSize(.title).padding(7)
                    
                    Link("Send Feedback", destination: URL(string: "mailto:monochromestudios@icloud.com")!).fontSize(.title).padding(7)
                    
                    ListSection(title: madeInMoscowString) {
                        PersonCard(name: alexeyString, description: "@FetchRequested", link: "https://twitter.com/FetchRequested", image: "alesha", icon: "twitter")
                        PersonCard(name: igorString, description: "@stopUIKit", link: "https://twitter.com/stopuikit", image: "igor", icon: "twitter")
                    }
                    
                    ListSection(title: newTimersString) {
                        PickerButton(title: notificationString, values: TimerItem.notificationSettings, value: self.$settings.notificationSettingDefault)
                        PremiumBadge() {
                            PickerButton(title: soundString, values: TimerItem.soundSettings, value: self.$settings.soundSettingDefault)
                        }
                        PremiumBadge() {
                            PickerButton(title: millisecondsString, values: TimerItem.precisionSettings, value: self.$settings.precisionSettingDefault)
                        }
                            
                        PremiumBadge() {
                            PickerButton(title: reusableString, values: TimerItem.reusableSettings, value: self.$settings.isReusableDefault)
                        }
                        
                        PremiumBadge() {
                            PickerButton(title: showInLogString, values: [true.yesNo, false.yesNo], value: self.$settings.showInLogDefault.yesNo)
                        }
                        
                    }
                    
                    ListSection(title: visualsString) {
                            PickerButton(title: fontString, values: [Font.Design.default.string, Font.Design.rounded.string], value: self.$settings.fontDesign.string)
                        
                        PremiumBadge() {
                            PickerButton(title: monochromeString, values: [true.yesNo, false.yesNo], value: self.$settings.isMonochrome.yesNo)
                        }
                        
                        PremiumBadge() {
                            PickerButton(title: logSeparatorsString, values: [true.onOff, false.onOff], value: self.$settings.showingDividers.onOff)
                        }
                                                
                    }
                    
                    
                }.padding(.leading, 21).padding(.bottom, 28).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                    
                }
        }
        
    }
}
