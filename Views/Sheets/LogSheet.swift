//
//  LogSheet.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 4/6/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI
import ASCollectionView

struct LogSheet: View {
    
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var settings: Settings
    @FetchRequest(fetchRequest: LogItem.getAllLogItems()) var logItems: FetchedResults<LogItem>
    
    @State private var selectedScreen = 0
    
    @State private var totalTimeSpent = "00:00"
    @State private var mostPopularTimer = "No Timer"
    @State private var mostPopularTimerCount = "Ran 0 Times"
    @State private var dailyAverage = "00:00"
    @State private var totalTimersRun = "0"
    
    var discard: () -> Void
    
    func update(_ result : FetchedResults<LogItem>)-> [[LogItem]]{
        return  Dictionary(grouping: result){ (element : LogItem)  in
            TimerItem.dateFormatter.string(from: element.timeStarted)
        }.values.sorted { $0[0].timeStarted > $1[0].timeStarted }
    }

        
//    var sections: [ASTableViewSection<Int>]
//    {
//        update(logItems).enumerated().map
//        { i, section in
//            ASTableViewSection(
//                id: i + 1,
//                data: section,
//                onSwipeToDelete: onSwipeToDelete,
//                contextMenuProvider: contextMenuProvider)
//            { item, _ in
//                LogItemCell(logItem: item)
//            }
//            .sectionHeader
//            {
//               VStack(spacing: 0)
//                {
//                    HStack() {
//                        Text(TimerItem.dateFormatter.string(from: section[0].timeStarted)).fontSize(.title).padding(7).padding(.leading, 21).padding(.vertical, 7)
//                        Spacer()
//                    }
//
//                    if settings.showingDividers {
//                        Divider()
//                    }
//               }.background(Color(UIColor.systemBackground))
//            }
//        }
//    }
    

    
    var body: some View {
        VStack(spacing: 0) {
            HeaderBar(leadingAction: discard,
                      leadingTitle: dismissString,
                      leadingIcon: "chevron.down",
                      trailingAction: clearLog,
                      trailingTitle: "Clear Log",
                      trailingIcon: "trash")
            Picker(selection: $selectedScreen, label: Text("What is your favorite color?")) {
                Text("Trends").tag(0)
                Text("History").tag(1)
            }.pickerStyle(SegmentedPickerStyle()).padding(.horizontal, 28).padding(.vertical, 7)
            if selectedScreen == 0 {
                VStack(spacing: 0)
                 {
                     HStack {
                         Text("This Week").fontSize(.title).padding(7).padding(.leading, 21).padding(.vertical, 7)
                         Spacer()
                     }
                    
                     
                     if settings.showingDividers {
                         Divider()
                     }
                    ScrollView {
                    VStack(spacing: 14) {
                        Spacer().frame(height: 14)
                        InsightRow(icon: "clock.fill", color: Color(.systemTeal), title: "Total Time Spent", item: $totalTimeSpent, value: $mostPopularTimerCount, subtitle: "Good job tracking your time this week! Be sure to track all your activities next week. Great!")
                        InsightRow(icon: "heart.circle.fill", color: Color(.systemPink), title: "Most Popular Timer", item: $mostPopularTimer, value: $mostPopularTimerCount, showingValue: true, subtitle: "Wow! You've really run this Timer a lot, haven't you. Hope you're doing something productive.")
                        InsightRow(icon: "arrow.right.circle.fill", color: Color(.systemPurple), title: "Daily Average", item: $dailyAverage, value: $mostPopularTimerCount, subtitle: "Looks like you have good average productivity. Well done, mate!")
                        InsightRow(icon: "number.circle.fill", color: Color(.systemOrange), title: "Total Timers Run", item: $totalTimersRun, value: $mostPopularTimerCount, subtitle: "That's a lot of Timers! Keep tracking your activities to be more aware of your time-spending.")
                        Spacer()
                    }.padding(.leading, 21)
                    }
                }.background(Color(UIColor.systemBackground))
                
            } else {
                Spacer()
                Text("Under Construction 🚧")
                Spacer()
                Spacer()
//                List(update(logItems), id: \.self) { section in
//                    ForEach(section) { logItem in
//                        LogView(logItem: logItem)
//                    }
//                }

//                ASTableView(style: .plain, sections: sections).separatorsEnabled(settings.showingDividers)
//                .alwaysBounce(true)
            }
            
        
        }.onAppear {
            self.settings.hasSeenTrends = true
            self.calculateValues(logItems: self.logItems)
        }

    }
    
    func clearLog() {
        if logItems.count > 0 {
            for i in 0...logItems.count-1 {
                context.delete(logItems[i])
                
            }
        }
    }
    
    func contextMenuProvider(int: Int, logItem: LogItem) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (suggestedActions) -> UIMenu? in
            let deleteCancel = UIAction(title: "Cancel", image: UIImage(systemName: "xmark")) { action in }
            let deleteConfirm = UIAction(title: NSLocalizedString("delete", comment: "Delete"), image: UIImage(systemName: "trash"), attributes: self.settings.isMonochrome ? UIMenuElement.Attributes() : .destructive) { action in

               
            }


            // The delete sub-menu is created like the top-level menu, but we also specify an image and options
            let delete = UIMenu(title: NSLocalizedString("delete", comment: "Delete"), image: UIImage(systemName: "trash"), options: self.settings.isMonochrome ? UIMenu.Options() : .destructive, children: [deleteCancel, deleteConfirm])
            

            

            let info = UIAction(title: NSLocalizedString("showDetails", comment: "Show Details"), image: UIImage(systemName: "ellipsis")) { action in
                print("fuck")
            }

            // Then we add edit as a child of the main menu
            let mainMenu = UIMenu(title: "", children: [delete, info])
            return mainMenu
        }
        return configuration
    }
    
    func onSwipeToDelete(int: Int, logItem: LogItem, completionHandler: (Bool) -> Void) {
        withAnimation(.default) {
            context.delete(logItem)
        }
    }
    
    func calculateValues(logItems: FetchedResults<LogItem>) {
        let logItemsThisWeek = logItems.filter({
            $0.timeFinished > Date().addingTimeInterval(-604800)
        })
        
        totalTimersRun = String(logItemsThisWeek.count)
        
        mostPopularTimer = mostFrequent(array: logItemsThisWeek)?.value ?? ""
        mostPopularTimerCount = "Ran \(String(mostFrequent(array: logItemsThisWeek)?.count ?? 0)) Times"
        
        totalTimeSpent = totalTime(array: logItemsThisWeek)
        
        dailyAverage = averageTime(array: logItemsThisWeek)
        
        // logItem.timeFinished.timeIntervalSince(logItem.timeStarted).relativeStringFromNumber()
        
        
        
        
    }
    

    func mostFrequent(array: [LogItem]) -> (value: String, count: Int)? {

        let counts = array.reduce(into: [:]) { $0[$1.title, default: 0] += 1 }

        if let (value, count) = counts.max(by: { $0.1 < $1.1 }) {
            return (value, count)
        }

        // array was empty
        return nil
    }
    
    func totalTime(array: [LogItem]) -> String {
        var sum: TimeInterval = 0
        
        for i in 0..<array.count {
            sum += array[i].timeFinished.timeIntervalSince(array[i].timeStarted)
        }
        
        return sum.relativeStringFromNumber()
    }
    
    func averageTime(array: [LogItem]) -> String {
        var sum: TimeInterval = 0
        
        for i in 0..<array.count {
            sum += array[i].timeFinished.timeIntervalSince(array[i].timeStarted)
        }
        
        return (sum/7).relativeStringFromNumber()
    }

    
    
}


