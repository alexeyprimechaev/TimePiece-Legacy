//
//  SubscriptionButton.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 4/20/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct SubscriptionButton: View {
    
    
    @State var title = LocalizedStringKey("")
    
    @State var promo = LocalizedStringKey("")
    
    @State var price = ""
    
    @State var duration = LocalizedStringKey("")
    
    @State var isAccent = false
    
    @State var isFree = false
    
    @Binding var hasFinishedLoading: Bool
    
    
    var action: () -> Void
    
    var body: some View {
        
        Button {
            action()
        } label: {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .foregroundColor(isAccent ? .primary : Color("button.gray"))
                HStack {
                    
                    if isFree {
                        Spacer()
                    }
                    
                    VStack(alignment: isFree ? .center : .leading, spacing: 4) {
                        Text(title).fontSize(.smallTitle)
                        Text(promo).font(.system(size: 12, weight: .medium, design: .default))
                    }
                    
                    Spacer()
                    
                    if !isFree {
                        if hasFinishedLoading {
                            VStack(alignment: .trailing, spacing: 4) {
                                Text(price).fontSize(.smallTitle)
                                Text(duration).font(.system(size: 12, weight: .medium, design: .default))
                            }
                        } else {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: isAccent ? Color(.systemBackground) : .primary))
                                .padding(.trailing, 7)
                        }
                    }
                    
                }.padding(.horizontal, 14).foregroundColor(isAccent ? (Color(.systemBackground)) : .primary)
            }.frame(height: 66)
        }
        
    }
}

