//
//  PropertyView.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/16/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct PropertyView: View {
    
    @State var title = String()
    
    @ObservedObject var timer = TimerPlus()
        
    var body: some View {
        HStack(alignment: .bottom, spacing: 7) {
            if(title == "Title") {
                Text(self.timer.title ?? "Title")
                .font(.largeTitle)
                .fontWeight(.bold)
                .opacity(1)
            } else if (title == "Created at") {
                Text(TimerPlus.dateFormatter.string(from: timer.createdAt ?? Date()))
                .font(.largeTitle)
                .fontWeight(.bold)
                .opacity(1)
            } else if (title == "Left"){
                Text("\((self.timer.timeFinished ?? Date()).timeIntervalSince(timer.timeStarted ?? Date()).stringFromTimeInterval(precisionSetting: self.timer.precisionSetting ?? "Off"))")
                .font(.largeTitle)
                .fontWeight(.bold)
                .opacity(1)
            } else {
                Text("\((self.timer.totalTime as! TimeInterval).stringFromTimeInterval(precisionSetting: self.timer.precisionSetting ?? "Off"))")
                .font(.largeTitle)
                .fontWeight(.bold)
                .opacity(1)
            }
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.bottom, 5)
                .opacity(0.5)
        }
        .padding(7)
    
    }
}

