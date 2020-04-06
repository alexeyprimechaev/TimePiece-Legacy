//
//  LogSheet.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 4/6/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI

struct LogSheet: View {
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: LogItem.getAllLogItems()) var logItems: FetchedResults<LogItem>
    
    var body: some View {
        List(logItems) { logItem in
            Text(logItem.title == "" ? "Timer ⏱" : logItem.title)
        }.onAppear {
            dump(self.logItems)
        }
    }
}

struct LogSheet_Previews: PreviewProvider {
    static var previews: some View {
        LogSheet()
    }
}
