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
            HStack(spacing: 0) {
                Text(logItem.origin?.title ?? logItem.title == "" ? Strings.timer : LocalizedStringKey(logItem.title))
                Spacer()
                Text(logItem.isStopwatch ? logItem.isDone ? logItem.time : currentTime : logItem.timeFinished.timeIntervalSince(Date()) < 0 ? logItem.time : currentTime)
            }
            Spacer().frame(height: 7)
            HStack(spacing: 0) {
                Text(TimeItem.currentTimeFormatter.string(from: logItem.timeStarted))
                Text(" – ")
                Text(logItem.isDone ? TimeItem.currentTimeFormatter.string(from: logItem.timeFinished) : "Now")
                Spacer()
            }.opacity(0.5)
            if settings.showingDividers {
                Divider().padding(.top, 7)
            }
        }.fontSize(.smallTitle)
        .padding(7).padding(.bottom, 7)
        
        .onAppear {
            currentTime = Date().timeIntervalSince(logItem.timeStarted).relativeStringFromNumber()
        }
        
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


enum LogSegment: String, Equatable, CaseIterable {
    case days = "Days", weeks = "Weeks", months = "Months", years = "Years"
}

struct LogSection: View {
    
    @State var segment: LogSegment
    @State var logItemSection: [LogItem]
    
    var body: some View {
        VStack(spacing: 0) {
            LogHeader(sectionDate: logItemSection[0].timeStarted, segment: segment)
            VStack(spacing: 0) {
                ForEach(logItemSection) { logItem in
                    LogItemCell(logItem: logItem)
                }
            }
        }
    }
}

struct LogHeader: View {
    
    var sectionDate: Date
    var segment: LogSegment
    var title: String
    
    init(sectionDate: Date, segment: LogSegment) {
        self.sectionDate = sectionDate
        self.segment = segment
        
        switch segment {
        case .days:
            self.title = "Day"
        case .weeks:
            if Date().week == sectionDate.week {
                self.title = "This Week"
            } else if Date().week.weekOfYear ?? 0 - 1 == sectionDate.week.weekOfYear {
                self.title = "Last Week"
            } else {
                self.title = ""
            }
            print("problemo")
        case .months:
            self.title = "Month"
        case .years:
            self.title = "Year"
        }
        
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 14) {
                Text(title)
                
                if segment == .weeks {
                    HStack(spacing: 0) {
                        Text(sectionDate.startOfWeek, formatter: TimeItem.dateFormatter)
                        Text(" – ")
                        Text(sectionDate.endOfWeek, formatter: TimeItem.dateFormatter)
                    }.opacity(0.5)
                }
            }.font(.title2.bold())
            HStack(spacing: 14) {
                Text("🍳 25 Timers")
                Text("🍳 25 Timers")
                Text("🍳 25 Timers")
                Text("🍳 25 Timers")
            }.fontSize(.secondaryText)
        }.padding(.vertical, 14)
    }
}
