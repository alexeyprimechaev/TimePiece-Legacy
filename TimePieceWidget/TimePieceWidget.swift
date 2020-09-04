//
//  TimePieceWidget.swift
//  TimePieceWidget
//
//  Created by Alexey Primechaev on 9/3/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import WidgetKit
import SwiftUI
import CoreData

struct Provider: TimelineProvider {
    
    var managedObjectContext: NSManagedObjectContext
    
    
    init(context : NSManagedObjectContext) {
        self.managedObjectContext = context
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), timer: TimerItem())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), timer: TimerItem())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, timer: TimerItem())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    
    
    let date: Date
    let timer: TimerItem
}

struct TimePieceWidgetEntryView : View {
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: TimerItem.getAllTimers()) var timerItems: FetchedResults<TimerItem>
    
    var entry: Provider.Entry

    var body: some View {
        Text(timerItems[0].title)
    }
}

@main
struct TimePieceWidget: Widget {
    let kind: String = "TimePieceWidget"
    

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(context: persistentContainer.viewContext)) { entry in
            TimePieceWidgetEntryView(entry: entry).environment(\.managedObjectContext, persistentContainer.viewContext)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
    
    var persistentContainer: NSPersistentCloudKitContainer = {
            return PersistenceController.shared.container
    }()
}
