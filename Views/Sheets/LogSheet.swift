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

func logItemsGrouped(_ result: FetchedResults<LogItem>, by segment: LogSegment) -> [[LogItem]] {
    switch segment {
    case .weeks:
        return logItemWeeks(result)
    case .days:
        return logItemDays(result)
    case .months:
        return logItemMonths(result)
    case .years:
        return logItemYears(result)
    }
}

func logItemWeeks(_ result: FetchedResults<LogItem>)-> [[LogItem]]{
    return result.group { $0.timeStarted.week }.sorted { $0[0].timeStarted > $1[0].timeStarted }
}

func logItemMonths(_ result: FetchedResults<LogItem>)-> [[LogItem]]{
    return result.group { $0.timeStarted.month }.sorted { $0[0].timeStarted > $1[0].timeStarted }
}

func logItemYears(_ result: FetchedResults<LogItem>)-> [[LogItem]]{
    return result.group { $0.timeStarted.year }.sorted { $0[0].timeStarted > $1[0].timeStarted }
}

func logItemDays(_ result: FetchedResults<LogItem>)-> [[LogItem]]{
    return result.group { $0.timeStarted.day }.sorted { $0[0].timeStarted > $1[0].timeStarted }
}



struct LogSheet: View {
    
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var settings: Settings
    @FetchRequest(fetchRequest: LogItem.getAllLogItems()) var logItems: FetchedResults<LogItem>
    
    @State var selectedSegment: LogSegment = .days
    
    var discard: () -> ()
    
    
    var body: some View {
        
        
        VStack(spacing:0) {
            HeaderBar {
                RegularButton(title: Strings.dismiss, icon: "chevron.down") {
                    discard()
                }
            }
            Picker(selection: $selectedSegment, label: Text("What is your favorite color?")) {
                ForEach(LogSegment.allCases, id: \.self) { value in
                                    Text(value.rawValue)
                                        .tag(value)
                                }

            }.pickerStyle(SegmentedPickerStyle()).padding(.horizontal, 28).padding(.vertical, 7).accentColor(.primary)
            TitledScrollView {
                VStack {
                    ForEach(logItemsGrouped(logItems, by: selectedSegment) , id: \.self) { logItemSection in
                        LogSection(segment: selectedSegment , logItemSection: logItemSection)
                        
                    }
                }.padding(.top, 14)
                
                
            }
        }
        .onAppear {
            UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.primary)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.systemBackground], for: .selected)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.primary)], for: .normal)
        }
        
    }
}
