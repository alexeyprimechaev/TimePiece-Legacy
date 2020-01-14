//
//  ContentView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/5/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: TimerPlus.getAllTimers()) var timers: FetchedResults<TimerPlus>
    
    var body: some View {
        ScrollView() {
            VStack(alignment: .leading, spacing: 14) {
                ForEach(timers) { timer in
                    TimerView(timer: timer)
                }
                Button(action: {
                    TimerPlus.newTimer(totalTime: 10, title: "Eggs 😃", context: self.context)
                }) {
                    VStack(alignment: .leading) {
                        Text("+")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.primary)
                        Text("New Timer")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.primary)
                            .opacity(0.5)
                        
                    }
                }
                .buttonStyle(DeepButtonStyle())
            }
            .padding(.leading, 21)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
