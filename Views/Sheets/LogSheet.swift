//
//  LogSheet.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 5/10/21.
//  Copyright © 2021 Alexey Primechaev. All rights reserved.
//

import SwiftUI

extension Sequence {
    func group<GroupingType: Hashable>(by key: (Iterator.Element) -> GroupingType) -> [[Iterator.Element]] {
        var groups: [GroupingType: [Iterator.Element]] = [:]
        var groupsOrder: [GroupingType] = []
        forEach { element in
            let key = key(element)
            if case nil = groups[key]?.append(element) {
                groups[key] = [element]
                groupsOrder.append(key)
            }
        }
        return groupsOrder.map { groups[$0]! }
    }
}


extension Date {
    
    var startOfWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return gregorian.date(byAdding: .day, value: 1, to: sunday ?? Date()) ?? Date()
    }
    
    var endOfWeek: Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return gregorian.date(byAdding: .day, value: 7, to: sunday ?? Date()) ?? Date()
    }
    
    var week: DateComponents {
        get {
            let calendar = Calendar.current
            let component = calendar.dateComponents([.weekOfYear, .year], from: self)
            
            return component
        }
    }
    
    var month: DateComponents {
        get {
            let calendar = Calendar.current
            let component = calendar.dateComponents([.month, .year], from: self)
            
            return component
        }
    }
    var year: DateComponents {
        get {
            let calendar = Calendar.current
            let component = calendar.dateComponents([.year], from: self)
            
            return component
        }
    }
    var day: DateComponents {
        get {
            
            let calendar = Calendar.current
            let component = calendar.dateComponents([.day, .year, .month], from: self)
            
            
            print(component)
            return component
        }
    }
}

func logItemsGrouped(_ result: [FetchedResults<LogItem>.Element], by segment: LogSegment) -> [[LogItem]] {
    
    let logItemsFiltered: [LogItem] = result.filter{$0.timeFinished.timeIntervalSince($0.timeStarted) > 2}
    switch segment {
    case .weeks:
        return logItemWeeks(logItemsFiltered)
    case .days:
        return logItemDays(logItemsFiltered)
    case .months:
        return logItemMonths(logItemsFiltered)
    case .years:
        return logItemYears(logItemsFiltered)
    }
}

func logItemWeeks(_ result: [LogItem])-> [[LogItem]]{
    return result.group { $0.timeStarted.week }.sorted { $0[0].timeStarted > $1[0].timeStarted }
}

func logItemMonths(_ result: [LogItem])-> [[LogItem]]{
    return result.group { $0.timeStarted.month }.sorted { $0[0].timeStarted > $1[0].timeStarted }
}

func logItemYears(_ result: [LogItem])-> [[LogItem]]{
    return result.group { $0.timeStarted.year }.sorted { $0[0].timeStarted > $1[0].timeStarted }
}

func logItemDays(_ result: [LogItem])-> [[LogItem]]{
    return result.group { $0.timeStarted.day }.sorted { $0[0].timeStarted > $1[0].timeStarted }
}



struct LogSheet: View {
    
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var appState: AppState
    @FetchRequest(fetchRequest: LogItem.getAllLogItems()) var logItems: FetchedResults<LogItem>
    
    @State var selectedSegment: LogSegment = .weeks
    
    @State var title: String = ""
    
    var discard: () -> ()
    
    
    var body: some View {
        
        
        VStack(alignment: .leading, spacing:0) {
            HeaderBar {
                RegularButton(title: Strings.dismiss, icon: "chevron.down") {
                    discard()
                }
            }
            Text("Log").fontSize(.title).padding(.horizontal, 28).padding(.bottom, 7)
            Picker(selection: $selectedSegment, label: Text("What is your favorite color?")) {
                ForEach(LogSegment.allCases, id: \.self) { value in
                                    Text(value.rawValue)
                                        .tag(value)
                                }

            }.pickerStyle(SegmentedPickerStyle()).padding(.horizontal, 28).padding(.vertical, 7).accentColor(.primary)
            TitledScrollView {
                VStack {
                    switch selectedSegment {
                    case .weeks:
                        LazyVStack {
                            ForEach(logItemsGrouped(title == "" ? logItems.filter{ $0.title == $0.title } : logItems.filter{$0.title == title}, by: .weeks) , id: \.self) { logItemSection in
                                LogSection(segment: .weeks, logItemSection: logItemSection, isCompact: true).environmentObject(appState).environmentObject(settings)
                                
                            }
                        }
                    case .days:
                        LazyVStack {
                        ForEach(logItemsGrouped(title == "" ? logItems.filter{ $0.title == $0.title } : logItems.filter{$0.title == title}, by: .days) , id: \.self) { logItemSection in
                            LogSection(segment: .days, logItemSection: logItemSection, isCompact: true).environmentObject(appState).environmentObject(settings)
                            
                        }
                        }
                    case .months:
                        LazyVStack {
                        ForEach(logItemsGrouped(title == "" ? logItems.filter{ $0.title == $0.title } : logItems.filter{$0.title == title}, by: .months) , id: \.self) { logItemSection in
                            LogSection(segment: .months, logItemSection: logItemSection, isCompact: true).environmentObject(appState).environmentObject(settings)
                            
                        }
                        }
                    case .years:
                        LazyVStack {
                        ForEach(logItemsGrouped(title == "" ? logItems.filter{ $0.title == $0.title } : logItems.filter{$0.title == title}, by: .years) , id: \.self) { logItemSection in
                            LogSection(segment: .years, logItemSection: logItemSection, isCompact: true).environmentObject(appState).environmentObject(settings)
                            
                        }
                        }
                    }
                    
                    PremiumBadge(noLabel: true){}

                }.padding(.top, 14)
                
                
            }
        }
        .onChange(of: selectedSegment) { newValue in
            if settings.isSubscribed {
                
            } else {
                self.selectedSegment = .weeks
                settings.showingSubscription = true
            }
        }
        .onAppear {
            UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.primary)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.systemBackground], for: .selected)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.primary)], for: .normal)
        }
        
    }
    
}
