//
//  NotificationView.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 5/27/21.
//  Copyright © 2021 Alexey Primechaev. All rights reserved.
//

import SwiftUI
import Combine

struct NotificationsView: View {
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: TimeItem.getAllTimeItems()) var timeItems: FetchedResults<TimeItem>
    
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        
        if let timeItem: TimeItem = timeItems.filter{$0.isRunning == true}.filter{$0.remainingTime == 0}.reversed().first {
            NotificationView(timeItem: timeItem)
        } else {
            EmptyView()
        }
                
                    
            
        
    }
}

struct NotificationView: View {
    
    @ObservedObject var timeItem: TimeItem
    
    @State private var timeout = 0.0
    
    @State private var show = true
    
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        if show {
        HStack {
            VStack(alignment: .leading) {
                Text(timeItem.title.isEmpty ? timeItem.isStopwatch ? "Stopwatch ⏱" : Strings.timer : LocalizedStringKey(timeItem.title)).fontSize(.smallTitle)
            }
            Spacer()
            Text("Finished at \(TimeItem.currentTimeFormatter.string(from: timeItem.timeFinished))").opacity(0.5).fontSize(.smallTitle)
        }
        .padding(14)
        .padding(.vertical, 7)
        .background(RoundedRectangle(cornerRadius: 12, style: .continuous).foregroundColor(Color(.systemGray6)))
        .padding(.vertical, 7)
        .padding(.horizontal, 28)
        
    .onReceive(timer, perform: { _ in
        timeout += 1
        print("hey")
        if timeout > 2 {
            show = false
            self.timer.upstream.connect().cancel()
        }
    })
        } else {
            EmptyView()
        }
        
        
    }
}


struct NotificationModifier: ViewModifier {



    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
                .zIndex(0)
            NotificationsView()
                .zIndex(1)
                .animation(.default)
                .transition(AnyTransition.opacity.animation(.default).combined(with: .move(edge: .top))) 

        
        }
    }

}

extension View {
    func notification() -> some View {
        self.modifier(NotificationModifier())
    }
}

//struct NotificationView_Previews: PreviewProvider {
//    static var previews: some View {
//        NotificationView()
//            .previewLayout(.sizeThatFits).environmentObject(Settings())
//    }
//}

