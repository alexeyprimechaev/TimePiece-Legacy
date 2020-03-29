//
//  SubscriptionSheet.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 3/9/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct SubscriptionSheet: View {
    
    var discard: () -> ()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            HeaderBar(leadingAction: { self.discard() }, leadingTitle: "Dismiss", leadingIcon: "xmark", trailingAction: {}, trailingTitle: "Restore", trailingIcon: "arrow.clockwise")
            
            VStack(alignment: .leading, spacing: 0) {
                
                HStack(alignment: .bottom, spacing: 4) {
                    Text("TimePiece")
                        .title()
                        
                    Image("PlusIcon")
                        .padding(.bottom, 9)
                }.padding(7)
                ScrollView() {
                    VStack(alignment: .leading, spacing: 0) {
                        Spacer()
                        SubscriptionBadge(icon: "arrow.clockwise", title: "Reusable Timers. Unlimited.", subtitle: "Tut tozhe tekst", textOffset: 4).offset(x: 3)
                        Spacer()
                        SubscriptionBadge(icon: "ellipsis", title: "Higher Precision", subtitle: "Display Milliseconds", textOffset: 3).offset(x: 2)
                        Spacer()
                        SubscriptionBadge(icon: "1.circle", title: "Control notifications & sounds", subtitle: "For each timer separately", textOffset: 1).offset(x: 1)
                        Spacer()
                        SubscriptionBadge(icon: "wand.and.stars", title: "Change App’s appearance", subtitle: "Pick between fonts and colors")
                        Spacer()
                        
 
                    }
                }
                Spacer()
                HStack(spacing: 0) {
                    Spacer().frame(width:7)
                    VStack() {
                        MainButton(icon: "creditcard.fill", title: "Free Trial", highPriority: true, action: {})
                        Text("7 days free,").smallTitle()
                        Text("then 149 RUB/Month").secondaryText()
                    }
                    Spacer().frame(width:28)
                    VStack() {
                        MainButton(icon: "creditcard.fill", title: "Yearly", action: {})
                        Text("50% Off").smallTitle()
                        Text("890 RUB/Year").secondaryText()
                    }
                    Spacer().frame(width:28)
                }.padding(.bottom, 14)
                Text("Payment will be charged to iTunes Account at confirmation of purchase. Subscription automatically renews unless auto-renew is turned off at least 24 hours before the end of the current period.").secondaryText().padding(7).padding(.bottom, 14)
                HStack(spacing: 14) {
                    HStack() {
                        Image(systemName: "doc")
                        Text("Privacy Policy")
                    }.smallTitle()
                    HStack() {
                        Image(systemName: "doc")
                        Text("Terms of Service")
                    }.smallTitle()
                }.padding(7)
                Spacer()
            }.padding(.leading, 21)
        }
        
    }
}
