//
//  PremiumBadge.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 3/5/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct PremiumBadge<Content:View>: View {

    let content: Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        VStack(alignment: .leading, spacing: -4) {
            if !self.settings.isSubscribed {
                HStack(alignment: .center, spacing: 0) {
                    Image(systemName: "star.fill").font(.system(size: 9, weight: .semibold, design: settings.fontDesign)).padding(.trailing, 3)
                    Text("PLUS").font(.system(size: 13, weight: .semibold, design: settings.fontDesign))
                }.padding(.leading, 9)
            }
            content.disabled(!settings.isSubscribed)
        }.onTapGesture {
            if self.settings.isSubscribed {
                
            } else {
                self.settings.showingSubscription = true
            }
            
        }
        .sheet(isPresented: $settings.showingSubscription) {
            SubscriptionSheet(discard: {
                self.settings.showingSubscription = false
            }).environmentObject(self.settings)
        }
        
        
    }
}

