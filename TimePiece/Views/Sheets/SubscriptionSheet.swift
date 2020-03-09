//
//  SubscriptionSheet.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 3/9/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct SubscriptionSheet: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack() {
                Button(action: {
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
            VStack(alignment: .leading, spacing: 0) {
                
                Text("TimePiece").titleStyle().padding(7)
                Spacer()
                HStack(spacing: 0) {
                    Spacer().frame(width:7)
                    VStack() {
                        MainButton(icon: "creditcard.fill", title: "Free Trial", highPriority: true, action: {})
                        Text("7 days free,").smallTitleStyle()
                        Text("then 149 RUB/Month").font(.system(size: 14, weight: .medium))
                    }
                    Spacer().frame(width:28)
                    VStack() {
                        MainButton(icon: "creditcard.fill", title: "Yearly", action: {})
                        Text("7 days free,").smallTitleStyle()
                        Text("then 149 RUB/Month").font(.system(size: 14, weight: .medium))
                    }
                    Spacer().frame(width:28)
                }.padding(.bottom, 14)
                Text("Payment will be charged to iTunes Account at confirmation of purchase. Subscription automatically renews unless auto-renew is turned off at least 24 hours before the end of the current period.").font(.system(size: 14, weight: .medium)).padding(7).multilineTextAlignment(.center).padding(.bottom, 14)
                HStack(spacing: 14) {
                    HStack() {
                        Image(systemName: "doc")
                        Text("Privacy Policy")
                    }.smallTitleStyle()
                    HStack() {
                        Image(systemName: "doc")
                        Text("Terms of Service")
                    }.smallTitleStyle()
                }.padding(7).padding(.bottom, 21)
            }.padding(.leading, 21)
        }
        
    }
}

struct SubscriptionSheet_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionSheet()
    }
}
