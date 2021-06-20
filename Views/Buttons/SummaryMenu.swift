//
//  SummaryMenu.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 6/20/21.
//  Copyright © 2021 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct SummaryMenu: View {
    
    @ObservedObject var timeItem: TimeItem
    
    var delete: () -> ()
    
    var body: some View {
        Menu {
            Menu {
                Picker("Notification Setting", selection: $timeItem.notificationSetting) {
                    Label {
                        Text(NSLocalizedString(TimeItem.notificationSettings[0], comment: "value"))
                    } icon: {
                        Image(systemName: "bell.slash")
                    }.tag(TimeItem.notificationSettings[0])
                    Label {
                        Text(NSLocalizedString(TimeItem.notificationSettings[1], comment: "value"))
                    } icon: {
                        Image(systemName: "bell")
                    }.tag(TimeItem.notificationSettings[1])
                }
            } label: {
                Label {
                    Text("Notifications")
                } icon: {
                    Image(systemName: timeItem.notificationSetting == TimeItem.notificationSettings[1] ?  "bell" : "bell.slash")
                }
            }
            Menu {
                Text("Off")
                Text("15m")
                Text("30m")
                Text("60m")
                Text("2h")

            } label: {
                Label {
                    Text("Tap Me Every")
                } icon: {
                    Image(systemName: "30.circle")
                }
            }
            Menu {
                Picker("Sound Setting", selection: $timeItem.soundSetting) {
                    Label {
                        Text(NSLocalizedString(TimeItem.soundSettings[0], comment: "value"))
                    } icon: {
                        Image(systemName: "speaker.wave.1")
                    }.tag(TimeItem.soundSettings[0])
                    Label {
                        Text(NSLocalizedString(TimeItem.soundSettings[1], comment: "value"))
                    } icon: {
                        Image(systemName: "speaker.wave.3")
                    }.tag(TimeItem.soundSettings[1])
                }
            } label: {
                Label {
                    Text("Sound")
                } icon: {
                    Image(systemName: timeItem.soundSetting == TimeItem.soundSettings[1] ?  "speaker.wave.3" : "speaker.wave.1")
                }
            }
            Divider()
            DetailActions(timeItem: timeItem)
            RegularButton(title: Strings.delete, icon: "trash", isDestructive: true) {
                delete()
            }
        } label: {
            HStack {
                Image(systemName: timeItem.notificationSetting == TimeItem.notificationSettings[1] ?  "bell.fill" : "bell.slash.fill")
                Text("30m").fontSize(.secondaryText)
                Image(systemName: timeItem.soundSetting == TimeItem.soundSettings[1] ?  "speaker.wave.3.fill" : "speaker.wave.1.fill")
                Image(systemName: "ellipsis")
            }.font(.headline).imageScale(.small).fixedSize()
        }
    }
}
