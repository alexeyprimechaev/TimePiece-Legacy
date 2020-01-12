//
//  TimerPlusDetailView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/6/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct TimerPlusDetailView: View {
    
    @ObservedObject var timer = TimerPlus()
    
    var onDismiss: () -> ()
    
    var body: some View {
        
        NavigationView() {
            List() {
                Text("\(timer.time ?? Date(), formatter: TimerPlus.timeFormatter)")
                Text("\(timer.createdAt ?? Date(), formatter: TimerPlus.dateFormatter)")
            }
            .navigationBarTitle(timer.title ?? "Timer")
            .navigationBarItems(
                leading: Button(action: {
                    self.onDismiss()
                }, label: {
                    HStack(alignment: .center) {
                        Image(systemName: "xmark")
                        .font(.system(size: 11.0, weight: .heavy))
                        Text("Dismiss")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(Color.primary)
                    
                })
            )
        }
    }
}

struct TimerPlusDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TimerPlusDetailView(onDismiss: {})
    }
}
