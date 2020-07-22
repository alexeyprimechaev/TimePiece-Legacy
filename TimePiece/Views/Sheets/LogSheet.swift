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
                    }.background(Color(UIColor.systemBackground))
                    if settings.showingDividers {
                        Divider()
                    }
                }
            }
        }
    }
    

    
    var body: some View {
        VStack(spacing: 0) {
        HeaderBar(leadingAction: { self.discard() }, leadingTitle: "Dismiss", leadingIcon: "xmark", trailingAction: {})
            ASTableView(style: .plain, sections: sections).separatorsEnabled(settings.showingDividers)
            .alwaysBounce(true)
        
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


