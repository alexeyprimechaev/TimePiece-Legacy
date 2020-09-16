//
//  SubscriptionRow.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 3/10/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct SubscriptionRow: View {
    
    var icon = String()
    var title = LocalizedStringKey("")
    var subtitle = LocalizedStringKey("")
    
    var iconOffset: CGFloat = 0
    var textOffset: CGFloat = 0
    
    var body: some View {
        VStack(alignment: .center, spacing: 28) {
            Image(systemName: icon).font(.system(size: 156, weight: .light))
            VStack(spacing: 4) {
                Text(title).multilineTextAlignment(.center).font(Font.system(.title2).bold())
                if subtitle != LocalizedStringKey("") {
                    Text(subtitle)
                }
            }
        }.padding(7)
    }
}

struct SubscribtionPoints<Content:View>: View {
    
    let content: Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
        
    @State var selection = 0
    
    var body: some View {
        TabView(selection: $selection.animation()) {
            content
        }.tabViewStyle(PageTabViewStyle()).indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never)).frame(minHeight: 340, idealHeight: 340, maxHeight: 340, alignment: .center)

        .onReceive(Timer.publish(every: 5, on: .main, in: .common).autoconnect()) { time in
            withAnimation {
                if selection < 5 {
                    selection += 1
                } else {
                    selection = 0
                }
            }
            
            
        }
    }
}


struct SubscriptionRow_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionRow()
    }
}
