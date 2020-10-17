//
//  LogView.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 4/6/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct LogItemCell: View {
    
    @ObservedObject var logItem = LogItem()
    @EnvironmentObject var settings: Settings
    
    @State var currentTime = "00:00:00"
    
    var body: some View {
        
        VStack(spacing: 0) {
            Spacer().frame(height: 7)
            HStack(spacing: 0) {
                Spacer().frame(width: 28)
                Text(logItem.title == "" ? Strings.timer : LocalizedStringKey(logItem.title))
                Spacer()
                Text(logItem.isStopwatch ? logItem.isDone ? logItem.time : currentTime : logItem.timeFinished.timeIntervalSince(Date()) < 0 ? logItem.time : currentTime)
                Spacer().frame(width: 28)
            }
            Spacer().frame(height: 7)
            HStack(spacing: 0) {
                Spacer().frame(width: 28)
                Text(TimerItem.currentTimeFormatter.string(from: logItem.timeStarted))
                Text(" – ")
                Text(logItem.isDone ? TimerItem.currentTimeFormatter.string(from: logItem.timeFinished) : "Now")
                Spacer()
                Spacer().frame(width: 28)
            }.opacity(0.5)
            Spacer().frame(height: 14)
        }.fontSize(.smallTitle)
        
        .onReceive(Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()) { time in
            currentTime = Date().timeIntervalSince(logItem.timeStarted).relativeStringFromNumber()
        }
    }
    
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogItemCell()
    }
}
