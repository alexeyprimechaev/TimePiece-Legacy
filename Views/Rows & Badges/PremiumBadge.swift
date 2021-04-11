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
//            if !settings.isSubscribed {
//                HStack(alignment: .center, spacing: 0) {
//                    Image(systemName: "star.fill").font(.system(size: 9, weight: .semibold, design: settings.fontDesign)).padding(.trailing, 3)
//                    Text("PREMIUM").font(.system(size: 13, weight: .semibold, design: settings.fontDesign))
//                }.padding(.leading, 9)
//            }
            content.disabled(!settings.isSubscribed)
        }.onTapGesture {
            if settings.isSubscribed {
                
            } else {
                settings.showingSubscription = true
            }
            
        }
        .animation(nil)
        .fullScreenCover(isPresented: $settings.showingSubscription) {
            SubscriptionSheet {
                settings.showingSubscription = false
            }.environmentObject(settings)
        }
        
        
    }
}

