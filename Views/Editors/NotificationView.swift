//
//  NotificationView.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 5/27/21.
//  Copyright © 2021 Alexey Primechaev. All rights reserved.
//

import SwiftUI
import Combine

struct NotificationView: View {
    
    @State var title: String
    @State var timeFinished: Date
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
            }
            Spacer()
            Text("Finished at \(TimeItem.currentTimeFormatter.string(from: timeFinished))").opacity(0.5).fontSize(.smallTitle)
        }
        .padding(14)
        .padding(.vertical, 7)
        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).foregroundColor(Color(.systemGray6)))
        .padding(.vertical, 7)
        .padding(.horizontal, 28)
        
    }
}

struct NotificationModifier: ViewModifier {
    
    @State var title: String
    @State var timeFinished: Date
    
    @State private var timeout = 0.0
    
    @State private var show = false
    
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()

    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
            if show {
                    NotificationView(title: title, timeFinished: Date())
                        .transition(.move(edge: .top))
                        .animation(.default)
                        
            }
        }.onReceive(timer, perform: { _ in
            timeout += 1
            print("hey")
            if timeout > 2 {
                show = true
            }
            if timeout > 5 {
                show = false
                self.timer.upstream.connect().cancel()
            }
        })
    }
    
}

extension View {
    func notification(title: String, timeFinished: Date) -> some View {
        self.modifier(NotificationModifier(title: title, timeFinished: timeFinished))
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(title: "Eggs 🍳", timeFinished: Date())
            .previewLayout(.sizeThatFits).environmentObject(Settings())
    }
}
