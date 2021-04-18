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
    
    var discard: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing:0) {
            HeaderBar {
                RegularButton(title: Strings.discard, icon: "chevron.down") {
                    discard()
                }
            }
            
            TitledScrollView {
                
                VStack(alignment: .leading, spacing: 14) {
                    
                    Text(Strings.settings).fontSize(.title).padding(7)
                    
                    Link("Send Feedback", destination: URL(string: "mailto:monochromestudios@icloud.com")!).fontSize(.title).padding(7).foregroundColor(.blue)
                    
                    ListSection(title: Strings.madeInMoscow) {
                        PersonCard(name: Strings.alexey,
                                   description: "@FetchRequested",
                                   link: "https://twitter.com/FetchRequested",
                                   image: "alesha",
                                   icon: "twitter")
                        PersonCard(name: Strings.igor,
                                   description: "@stopUIKit",
                                   link: "https://twitter.com/stopuikit",
                                   image: "igor",
                                   icon: "twitter")
                    }
                    
                    ListSection(title: Strings.newTimers) {
                        PickerButton(title: Strings.notification, values: TimeItem.notificationSettings, controlledValue: $settings.notificationSettingDefault)
                        PremiumBadge {
                            PickerButton(title: Strings.sound, values: TimeItem.soundSettings, controlledValue: $settings.soundSettingDefault)
                        }
                        PremiumBadge {
                            PickerButton(title: Strings.milliseconds, values: TimeItem.precisionSettings, controlledValue: $settings.precisionSettingDefault)
                        }
                        
                        PremiumBadge {
                            PickerButton(title: Strings.reusable, values: TimeItem.reusableSettings, controlledValue: $settings.isReusableDefault)
                        }
                        
                        PremiumBadge {
                            PickerButton(title: Strings.showInLog, values: [false.yesNo, true.yesNo], controlledValue: $settings.showInLogDefault.yesNo)
                        }
                        
                    }
                    
                    ListSection(title: Strings.visuals) {
                        PickerButton(title: Strings.font, values: [Font.Design.default.string, Font.Design.rounded.string, Font.Design.serif.string, Font.Design.monospaced.string], controlledValue: $settings.fontDesign.string)
                        
                        PremiumBadge {
                            PickerButton(title: Strings.monochrome, values: [false.yesNo, true.yesNo], controlledValue: $settings.isMonochrome.yesNo)
                        }
                        
                        PremiumBadge {
                            PickerButton(title: Strings.logSeparators, values: [false.onOff, true.onOff], controlledValue: $settings.showingDividers.onOff)
                        }
                        
                    }
                    
                    
                }.padding(.bottom, 28).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                
            }
        }
        
    }
}
