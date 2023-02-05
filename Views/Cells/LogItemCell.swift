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
            if appState.editingLogScreen {
                if appState.selectedLogItems.contains(logItem) {
                    appState.selectedLogItems.removeAll { $0 == logItem }
                } else {
                    appState.selectedLogItems.append(logItem)
                }
                
            } else {
                appState.showingLogTotal.toggle()
            }
        } label: {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text(logItem.origin?.title ?? logItem.title == "" ? logItem.isStopwatch ? "Stopwatch ⏱" : Strings.timer : LocalizedStringKey(logItem.title))
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
        
        
        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).foregroundColor(Color("button.gray")))
        
        .onAppear {
            currentTime = Date().timeIntervalSince(logItem.timeStarted).relativeStringFromNumber()
        }
        
        .onReceive(Clock.regular) { time in
            currentTime = Date().timeIntervalSince(logItem.timeStarted).relativeStringFromNumber()
        }
        }.buttonStyle(RegularButtonStyle())
        .overlay(appState.editingLogScreen ? Image(systemName: appState.selectedLogItems.contains(logItem) ? "checkmark.circle.fill" : "circle").font(.title2).padding(7) : nil, alignment: .topTrailing)
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
    @EnvironmentObject var settings: Settings
    
    @State var isCompact: Bool
    @State var showingSheet = false
    
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
    
    init(segment: LogSegment, logItemSection: [LogItem], isCompact: Bool) {
        self.segment = segment
        self.logItemSection = logItemSection
        self.isCompact = isCompact
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            LogHeader(sectionDate: logItemSection[0].timeStarted, segment: segment, totalTimers: totalTimers, mostFrequent: mostFrequent, totalTimeSpent: totalTimeSpent, averageTimeSpent: averageTimeSpent)
                .padding(.horizontal, isCompact ? 0 : 21)
            Spacer().frame(height: 0)
            if !isCompact {
                TitledScrollView {
                    VStack(alignment: .leading, spacing: 7) {
                        ForEach(isCompact ? [LogItem](logItemSection.prefix(3)) : logItemSection) { logItem in
                            LogItemCell(logItem: logItem).environmentObject(appState)
                        }
                    }.padding(.horizontal, 7).padding(.vertical, 14)
                }
            } else {
                VStack(alignment: .leading, spacing: 7) {
                    ForEach(isCompact ? [LogItem](logItemSection.prefix(3)) : logItemSection) { logItem in
                        LogItemCell(logItem: logItem).environmentObject(appState)
                    }
                }.padding(.horizontal, 7)
            }
            if isCompact {
                HStack {
                    Spacer()
                    PremiumBadge(noLabel: true) {
                        RegularButton(title: "View All", icon: "chevron.right", isFlipped: true) {
                                self.showingSheet = true
                            
                        }
                    }.sheet(isPresented: $showingSheet) {
                        LogSectionSheet(logItemSection: logItemSection, segment: segment) {
                            self.showingSheet = false
                        }.environmentObject(appState).environmentObject(settings)
                    }
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
            if sectionDate.day == Date().day {
                self.title = "Today"
            } else if (self.sectionDate.day.day ?? 0) + 1 == (Date().day.day ?? 0) {
                self.title = "Yesterday"
            } else {
                self.title = TimeItem.dateFormatter.string(from: self.sectionDate)
            }
        case .weeks:
            if Date().week == sectionDate.week {
                self.title = "This Week"
            } else if (self.sectionDate.week.weekOfYear ?? 0 + 1) == (Date().week.weekOfYear ?? 0) {
                self.title = "Last Week"
            } else {
                self.title = ""
            }
            print("problemo")
        case .months:
            self.title = TimeItem.monthFormatter.string(from: self.sectionDate)
        case .years:
            self.title = TimeItem.yearFormatter.string(from: self.sectionDate)
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
            }.fontSize(.title2)
            HStack(spacing: 14) {
                Label {
                    Text(mostFrequent)
                } icon: {
                    Image(systemName: "heart.fill").foregroundColor(.red).padding(.trailing, -3)
                }
                Label {
                    Text(totalTimers)
                } icon: {
                    Image(systemName: "number.circle.fill").foregroundColor(.orange).padding(.trailing, -3)
                }
//                Label {
//                    Text(averageTimeSpent)
//                } icon: {
//                    Image(systemName: "plusminus.circle.fill").foregroundColor(.purple).padding(.trailing, -3)
//                }
                Label {
                    Text(totalTimeSpent)
                } icon: {
                    Image(systemName: "clock.fill").foregroundColor(.blue).padding(.trailing, -3)
                }
            }.fontSize(.secondaryText)
        }.padding(.vertical, 14).padding(.horizontal, 7)
    }
    
    
}
