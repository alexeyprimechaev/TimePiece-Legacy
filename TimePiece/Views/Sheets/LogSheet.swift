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
    @FetchRequest(fetchRequest: LogItem.getAllLogItems()) var logItems: FetchedResults<LogItem>
    
    var discard: () -> ()

    
    var body: some View {
        VStack() {
        HeaderBar(leadingAction: { self.discard() }, leadingTitle: "Dismiss", leadingIcon: "xmark", trailingAction: {})
        ASTableView(style: .plain, sections: [
            ASTableViewSection(id: 0, data: logItems) { logItem, _  in
                LogView(logItem: logItem)
                
            }
            ]).tableViewSeparatorsEnabled(false)
        
        }

    }
}

