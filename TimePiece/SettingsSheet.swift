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
            HStack() {
                Button(action: {
                    self.discard()
                }) {
                    HStack(alignment: .center) {
                        Image(systemName: "xmark")
                            .font(.system(size: 11.0, weight: .heavy))
                        Text("Dismiss")
                            .fontWeight(.semibold)
                    }
                    .padding(.leading, 28)
                    .padding(.trailing, 128)
                    .foregroundColor(.primary)
                    Spacer()
                }
                .frame(height: 52)
            }
            
            ScrollView() {
                
                VStack(alignment: .leading, spacing: 14) {
                    
                    Text("Settings").titleStyle().padding(7)
                    
                    ListSection(title: "Made in Moscow with ❤️ by") {
                        PersonCard(name: "Alexey Primechaev", description: "Creator, Designer, Developer", link: "https://twitter.com/numberl6", image: "alesha", icon: "twitter")
                        PersonCard(name: "Igor Dyachuk", description: "Designer", link: "https://twitter.com/stopuikit", image: "igor", icon: "twitter")
                    }
                    
                    ListSection(title: "Visuals") {
                        VStack(alignment: .leading, spacing: -4) {
                            PremiumBadge()
                            PickerButton(title: "Font", values: [Font.Design.default.string, Font.Design.rounded.string], value: self.$settings.fontDesign.string)
                        }
                    }
                    
                    ListSection(title: "New Timers") {
                        PickerButton(title: "Notifications", values: TimerPlus.notificationSettings, value: self.$settings.notificationSettingDefault)
                        PickerButton(title: "Sound", values: TimerPlus.soundSettings, value: self.$settings.soundSettingDefault)
                        VStack(alignment: .leading, spacing: -4) {
                            PremiumBadge()
                            PickerButton(title: "Milliseconds", values: TimerPlus.precisionSettings, value: self.$settings.precisionSettingDefault)
                        }
                        VStack(alignment: .leading, spacing: -4) {
                            PremiumBadge()
                            PickerButton(title: "Reusable", values: TimerPlus.reusableSettings, value: self.$settings.isReusableDefault)
                        }
                        
                    }
                    
                    
                }.padding(.leading, 21).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                    
                }
            }
        
    }
}
