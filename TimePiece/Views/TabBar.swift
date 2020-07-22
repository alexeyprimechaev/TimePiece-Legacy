//
//  TabBar.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 5/30/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct TabBar: View {
    
    var actions: [() -> ()]
    
    @EnvironmentObject var settings: Settings
    
    @State var showingSubscriptionSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 0) {
                Spacer().frame(width: 14)
                TabItem(title: newString,icon: "plus", action: { self.actions[0]() })
                TabItem(title: logString, icon: "tray", action: {
                    if self.settings.isSubscribed {
                        self.actions[1]()
                    } else {
                        self.showingSubscriptionSheet = true
                        print("oi mate")
                    }
                    
                })
                TabItem(title: settingsString, icon: "ellipsis.circle", action: { self.actions[2]() })
                Spacer()
            }
        }.betterSheet(isPresented: $showingSubscriptionSheet) {
            SubscriptionSheet(discard: {self.showingSubscriptionSheet = false}).environmentObject(self.settings)
        }
    }
}
