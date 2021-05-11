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
    @EnvironmentObject var appState: AppState
    
    @State var currentTime = "00:00:00"
    
    
    
    var body: some View {
        Button {
            appState.showingLogTotal.toggle()
        } label: {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text(logItem.origin?.title ?? logItem.title == "" ? Strings.timer : LocalizedStringKey(logItem.title))
                Spacer()
                
                
            }
            Spacer().frame(height: 7)
            if appState.showingLogTotal {
                Text(logItem.isStopwatch ? logItem.isDone ? logItem.time : currentTime : logItem.timeFinished.timeIntervalSince(Date()) < 0 ? logItem.time : currentTime).opacity(0.5)
            } else {
                Text("\(TimeItem.currentTimeFormatter.string(from: logItem.timeStarted)) – \(logItem.isDone ? TimeItem.currentTimeFormatter.string(from: logItem.timeFinished) : "Now")").opacity(0.5)
            }
            
            

        }.fontSize(.smallTitle)
        .padding(14)
        
        
        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).foregroundColor(Color(.systemGray6)))
        
        .onAppear {
            currentTime = Date().timeIntervalSince(logItem.timeStarted).relativeStringFromNumber()
        }
        
        .onReceive(Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()) { time in
            currentTime = Date().timeIntervalSince(logItem.timeStarted).relativeStringFromNumber()
        }
        }.buttonStyle(RegularButtonStyle())
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
    @EnvironmentObject var appState: AppState
    
    private var totalTimers: Binding<String> { Binding (
        get: { String(self.logItemSection.count) },
        set: { _ in }
        )
    }
    
    private var mostFrequent: Binding<String> { Binding (
        get: { calculateMostFrequent(array: logItemSection) },
        set: { _ in }
        )
    }
    
    private var totalTimeSpent: Binding<String> { Binding (
        get: { calculateTotalTime(array: logItemSection) },
        set: { _ in }
        )
    }
    
    private var averageTimeSpent: Binding<String> { Binding (
        get: { calculateAverageTime(array: logItemSection) },
        set: { _ in }
        )
    }
    
    init(segment: LogSegment, logItemSection: [LogItem]) {
        self.segment = segment
        self.logItemSection = logItemSection
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            LogHeader(sectionDate: logItemSection[0].timeStarted, segment: segment, totalTimers: totalTimers, mostFrequent: mostFrequent, totalTimeSpent: totalTimeSpent, averageTimeSpent: averageTimeSpent)
            Spacer().frame(height: 0)
            LazyVStack(alignment: .leading, spacing: 7) {
                ForEach(logItemSection) { logItem in
                    LogItemCell(logItem: logItem).environmentObject(appState)
                }
            }
            HStack {
                Spacer()
                RegularButton(title: "View All", icon: "chevron.right", isFlipped: true) {
                    
                }
            }
        }
    }
    
    func calculateMostFrequent(array: [LogItem]) -> String {
        
        
        let counts = array.reduce(into: [:]) { counts, logItem in
            counts[logItem.title, default: 0] += 1
        }

        if let (value, count) = counts.max(by: { $0.1 < $1.1 }) {
            if value == "" {
                    return "Timer ⏱"
            } else {
                return value
            }
        } else {
            return ""
        }
        
        
    }
    
    func calculateTotalTime(array: [LogItem]) -> String {
        var sum: TimeInterval = 0
        
        for i in 0..<array.count {
            sum += array[i].timeFinished.timeIntervalSince(array[i].timeStarted)
        }
        
        return sum.relativeStringFromNumber()
    }
    
    func calculateAverageTime(array: [LogItem]) -> String {
        var sum: TimeInterval = 0
        
        for i in 0..<array.count {
            sum += array[i].timeFinished.timeIntervalSince(array[i].timeStarted)
        }
        
        return (sum/Double(array.count)).relativeStringFromNumber()
    }
}

struct LogHeader: View {
    
    var sectionDate: Date
    var segment: LogSegment
    var title: String
    @Binding var totalTimers: String
    @Binding var mostFrequent: String
    @Binding var totalTimeSpent: String
    @Binding var averageTimeSpent: String
    
    init(sectionDate: Date, segment: LogSegment, totalTimers: Binding<String>, mostFrequent: Binding<String>, totalTimeSpent: Binding<String>, averageTimeSpent: Binding<String>) {
        self.sectionDate = sectionDate
        self.segment = segment
        
        self._totalTimers = totalTimers
        self._mostFrequent = mostFrequent
        self._totalTimeSpent = totalTimeSpent
        self._averageTimeSpent = averageTimeSpent
        
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
                if title == "" {
                    
                } else {
                    Text(title)
                }
                
                if segment == .weeks {
                    HStack(spacing: 0) {
                        Text(sectionDate.startOfWeek, formatter: TimeItem.dateFormatter)
                        Text(" – ")
                        Text(sectionDate.endOfWeek, formatter: TimeItem.dateFormatter)
                    }.opacity(0.5)
                }
            }.font(.title2.bold())
            HStack(spacing: 14) {
                Label {
                    Text(totalTimers)
                } icon: {
                    Image(systemName: "number.circle.fill").foregroundColor(.orange).padding(.trailing, -3)
                }
                Label {
                    Text(mostFrequent)
                } icon: {
                    Image(systemName: "heart.fill").foregroundColor(.red).padding(.trailing, -3)
                }
                Label {
                    Text(averageTimeSpent)
                } icon: {
                    Image(systemName: "plusminus.circle.fill").foregroundColor(.purple).padding(.trailing, -3)
                }
                Label {
                    Text(totalTimeSpent)
                } icon: {
                    Image(systemName: "clock.fill").foregroundColor(.blue).padding(.trailing, -3)
                }
            }.fontSize(.secondaryText)
        }.padding(.vertical, 14).padding(.horizontal, 7)
    }
    
    
}
