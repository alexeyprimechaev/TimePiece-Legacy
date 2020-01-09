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
            ScrollView() {
                VStack(alignment: .leading) {
                    ForEach(self.timers) { timer in
                        TimerPlusView(timer: timer)
                        .listRowInsets(EdgeInsets(top: 14, leading: 28, bottom: 14, trailing: 8))
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: Alignment.topLeading)

                }
                
                Button(action: {
                    let timer = TimerPlus(context: self.context)
                    timer.title = "Eggs 🍳"
                    timer.time = Date()
                    timer.createdAt = Date()
                    timer.isPaused = false

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
                            .foregroundColor(.black)
                        Text("New Timer")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .opacity(0.5)
                        
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                .listRowInsets(EdgeInsets(top: 14, leading: 28, bottom: 14, trailing: 8))


            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
