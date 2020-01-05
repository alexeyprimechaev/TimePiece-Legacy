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
            TitleBar()
            List() {
                ForEach(self.timers) { timer in
                    TimerPlusView(timer: timer)
                    .listRowInsets(EdgeInsets(top: 14, leading: 28, bottom: 14, trailing: 8))
                }
            }
            Button(action: {
                    let timer = TimerPlus(context: self.context)
                    timer.title = "Eggs 🍳"
                    timer.time = "3:29"
                    timer.createdAt = Date()
                    timer.isPaused = false

                    do {
                        try self.context.save()
                    } catch {
                        print(error)
                    }
                
            }) {
                Text("Add Rating")
                    .fontWeight(.semibold)
            }.padding(16)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
