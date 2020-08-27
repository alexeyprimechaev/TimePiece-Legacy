//
//  LogView.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 4/6/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct LogView: View {
    
    @ObservedObject var logItem = LogItem()
    @EnvironmentObject var settings: Settings
    
    @State var currentTime = Date()
    
    var body: some View {
        
        VStack(spacing: 0) {
            Spacer().frame(height: 7)
            HStack(spacing: 0) {
                Spacer().frame(width: 28)
                Text(logItem.title == "" ? timerString : LocalizedStringKey(logItem.title))
                Spacer()
                Text(logItem.timeFinished.timeIntervalSince(Date()) < 0 ? logItem.timeFinished.timeIntervalSince(logItem.timeStarted).relativeStringFromNumber() : currentTime.timeIntervalSince(logItem.timeStarted).relativeStringFromNumber())
                Spacer().frame(width: 28)
            }
            Spacer().frame(height: 7)
            HStack(spacing: 0) {
                Spacer().frame(width: 28)
                Text(TimerItem.currentTimeFormatter.string(from: logItem.timeStarted))
                Text(" – ")
                Text(TimerItem.currentTimeFormatter.string(from: logItem.timeFinished))
                Spacer()
                Spacer().frame(width: 28)
            }.opacity(0.5)
            Spacer().frame(height: 14)
        }.smallTitle()
        
        .onReceive(Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()) { time in
            self.currentTime = Date()
        }
    }
    
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView()
    }
}
