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
                    VStack(alignment: .leading, spacing: 21) {
                        SubscriptionBadge(icon: "arrow.clockwise.circle.fill", title: "Reusable Timers. Unlimited.", subtitle: "Create Timers that don't expire")
                        SubscriptionBadge(icon: "ellipsis.circle.fill", title: "Higher Precision", subtitle: "Millisecond accuracy")
                        SubscriptionBadge(icon: "bell.circle.fill", title: "Control notifications & sounds", subtitle: "For each timer separately")
                        SubscriptionBadge(icon: "star.circle.fill", title: "Customize appearance", subtitle: "Choose colors and fonts")
                        SubscriptionBadge(icon: "heart.circle.fill", title: "Support the creators", subtitle: "And invest in future features")
                        
 
                    }.padding(.top, 14)
                    
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
                }.padding(.bottom, 21)
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
                Spacer().frame(height: 14)
            }.padding(.leading, 21)
        }
        
    }
}
