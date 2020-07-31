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
    
    var discard: () -> ()
    
    func update(_ result : FetchedResults<LogItem>)-> [[LogItem]]{
        return  Dictionary(grouping: result){ (element : LogItem)  in
            TimerItem.dateFormatter.string(from: element.timeStarted)
        }.values.sorted() { $0[0].timeStarted > $1[0].timeStarted }
    }

        
    var sections: [ASTableViewSection<Int>]
    {
        update(logItems).enumerated().map
        { i, section in
            ASTableViewSection(
                id: i + 1,
                data: section,
                onSwipeToDelete: onSwipeToDelete,
                contextMenuProvider: contextMenuProvider)
            { item, _ in
                LogView(logItem: item)
            }
            .tableViewSetEstimatedSizes(rowHeight: 300, headerHeight: 56)
            .sectionHeader
            {
               VStack(spacing: 0)
                {
                    HStack() {
                        Text(TimerItem.dateFormatter.string(from: section[0].timeStarted)).title().padding(7).padding(.leading, 21).padding(.vertical, 7)
                        Spacer()
                    }
                    
                    if settings.showingDividers {
                        Divider()
                    }
               }.background(Color(UIColor.systemBackground))
            }
        }
    }
    

    
    var body: some View {
        VStack(spacing: 0) {
        HeaderBar(leadingAction: { self.discard() }, leadingTitle: "Dismiss", leadingIcon: "xmark", trailingAction: {})
            Picker(selection: $selectedScreen, label: Text("What is your favorite color?")) {
                Text("Insights").tag(0)
                Text("History").tag(1)
            }.pickerStyle(SegmentedPickerStyle()).padding(.horizontal, 28).padding(.vertical, 7)
            if selectedScreen == 0 {
                VStack(spacing: 0)
                 {
                     HStack() {
                         Text("This Week").title().padding(7).padding(.leading, 21).padding(.vertical, 7)
                         Spacer()
                     }
                    
                     
                     if settings.showingDividers {
                         Divider()
                     }
                    VStack(spacing: 14) {
                        Spacer().frame(height: 14)
                        InsightView(icon: "clock.fill", color: Color(.systemTeal), title: "Total Time Spent", item: "16 Hours 33 Minutes", subtitle: "Good job tracking your time this week! You're 17% up compared to the last week. Great!")
                        InsightView(icon: "bookmark.circle.fill", color: Color(.systemPink), title: "Most Popular Timer", item: "Bacon 🥓", value: "Ran 11 Times", subtitle: "Wow! You've really run this Timer a lot, haven't you. Hope you're doing something productiove.")
                        InsightView(icon: "arrow.right.circle.fill", color: Color(.systemPurple), title: "Daily Average", item: "3 Hours 11 Minutes", subtitle: "Looks like you have good average productivity. Well done, mate!")
                        InsightView(icon: "number.circle.fill", color: Color(.systemOrange), title: "Total Timers Run", item: "73", subtitle: "That's a lot of Timers! Keep tracking your activities to be more aware of your time-spending.")
                        Spacer()
                    }.padding(.leading, 21)
                }.background(Color(UIColor.systemBackground))
                
            } else {
                ASTableView(style: .plain, sections: sections).separatorsEnabled(settings.showingDividers)
                .alwaysBounce(true)
            }
            
        
        }

    }
    
    func contextMenuProvider(_ logItem: LogItem) -> UIContextMenuConfiguration? {
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
    
    func onSwipeToDelete(_ logItem: LogItem, completionHandler: (Bool) -> Void) {
        withAnimation(.default) {
            context.delete(logItem)
        }
    }
    
    
}


