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
    
    init() {
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().separatorStyle = .none
    }
    
    var body: some View {
        VStack() {
            List() {
                ForEach(timers) { timer in
                    TimerView(timer: timer)
                }
                Button(action: {
                    let timer = TimerPlus(context: self.context)
                    timer.title = "Eggs 🍳"
                    timer.time = 5
                    timer.createdAt = Date()
                    timer.timeStarted = Date()
                    timer.timeFinished =
                        timer.timeStarted?.addingTimeInterval(timer.time as! TimeInterval)
                    timer.isPaused = true

                    do {
                        try self.context.save()
                    } catch {
                        print(error)
                    }
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
                .buttonStyle(BorderlessButtonStyle())
            }
   
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
