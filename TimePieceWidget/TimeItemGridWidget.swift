//
//  TimeItemGridWidget.swift
//  TimePieceWidgetExtension
//
//  Created by Alexey Primechaev on 2/18/21.
//  Copyright © 2021 Alexey Primechaev. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData

struct SingleTimeItem {
    
    var isFinished = false
    
    let isPlaceholder: Bool
    let date: Date
    let title: String
    let totalTime: TimeInterval
    let remainingTime: TimeInterval
    let timeStarted: Date
    let timeFinished: Date
    let isStopwatch: Bool
    let isPaused: Bool
    let isRunning: Bool
    let uri: String?
    
    var url: URL? {
        get {
            if let linkID = self.uri {
                return URL(string: "timepiece://" + linkID)
            }
            return nil
        }
    }
    
}

struct MultipleTimeItemsEntry: TimelineEntry {
    
    let date: Date
    let timeItems: [SingleTimeItem]
    
    let configuration: MultipleConfigurationIntent
}

let placeholderSingleTimeItem = SingleTimeItem(isPlaceholder: true, date: Date(), title: "Placeholder", totalTime: 300, remainingTime: 300, timeStarted: Date(), timeFinished: Date(), isStopwatch: false, isPaused: true, isRunning: false, uri: nil)

struct TimeItemGridProvider: IntentTimelineProvider {
    
    
    let placeholderMultipleTimeItems = MultipleTimeItemsEntry(date: Date(), timeItems: [placeholderSingleTimeItem,placeholderSingleTimeItem,placeholderSingleTimeItem,placeholderSingleTimeItem], configuration: MultipleConfigurationIntent())
    
    
    func fetchTimeItemWithConfig(date: Date, configuration: MultipleConfigurationIntent) -> MultipleTimeItemsEntry {
        let context = PersistenceController.shared.container.viewContext
        let request = TimeItem.getAllTimeItems()
        
        var results = [TimeItem]()
        
        do { results = try context.fetch(request) }
        catch let error as NSError {print("error")}
        
        
        var timeItems = [SingleTimeItem]()
        
        
        
        switch configuration.timeItemGroup {
        case .running:
            for item in results {
                let timeItem = SingleTimeItem(isFinished: false, isPlaceholder: false, date: Date(), title: item.title, totalTime: item.totalTime, remainingTime: item.remainingTime, timeStarted: item.timeStarted, timeFinished: item.timeFinished, isStopwatch: item.isStopwatch, isPaused: item.isPaused, isRunning: item.isRunning, uri: item.objectID.uriRepresentation().absoluteString)
                
                if timeItem.isRunning {
                    timeItems.append(timeItem)
                }
            }
        case .unknown:
            for item in results {
                let timeItem = SingleTimeItem(isFinished: false, isPlaceholder: false, date: Date(), title: item.title, totalTime: item.totalTime, remainingTime: item.remainingTime, timeStarted: item.timeStarted, timeFinished: item.timeFinished, isStopwatch: item.isStopwatch, isPaused: item.isPaused, isRunning: item.isRunning, uri: item.objectID.uriRepresentation().absoluteString)
                timeItems.append(timeItem)
            }
            
            timeItems.sort {
                $0.timeFinished > $1.timeFinished
            }
        }
        
        if timeItems.count > 4 {
            timeItems = Array(timeItems[...4])
        } else if timeItems.count < 4 {
            var i = timeItems.count
            while i < 4 {
                timeItems.append(placeholderSingleTimeItem)
                i += 1
            }
        }
        
        
        
        return MultipleTimeItemsEntry(date: date, timeItems: timeItems, configuration: configuration)
        
        
        
        
        
    }
    
    
    
    func placeholder(in context: Context) -> MultipleTimeItemsEntry {
        return fetchTimeItemWithConfig(date: Date(), configuration: MultipleConfigurationIntent())
    }
    
    func getSnapshot(for configuration: MultipleConfigurationIntent, in context: Context, completion: @escaping (MultipleTimeItemsEntry) -> ()) {
        completion(fetchTimeItemWithConfig(date: Date(), configuration: MultipleConfigurationIntent()))
    }
    
    func getTimeline(for configuration: MultipleConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        var entries: [MultipleTimeItemsEntry] = []
        
        let currentDate = Date()
        
        entries.append(fetchTimeItemWithConfig(date: currentDate, configuration: configuration))
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}


struct TimeItemGridCell: View {
    
    @State var timeItem: SingleTimeItem
    
    var body: some View {
        Link(destination: URL(string: "https://www.apple.com")!) {
            VStack(alignment: .leading, spacing: 4) {
                Text(timeItem.title)
                Text(timeItem.timeFinished, style: .timer).opacity(0.5)
            }.font(.footnote.bold()).padding(.horizontal, 14).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading).background(ContainerRelativeShape().foregroundColor(Color(.systemGroupedBackground)))
        }
        
    }
    
}

struct TimeItemGridEntryView: View {
    
    var entry: TimeItemGridProvider.Entry
    
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                TimeItemGridCell(timeItem: entry.timeItems[0])
                TimeItemGridCell(timeItem: entry.timeItems[1])
            }
            HStack(spacing: 8) {
                TimeItemGridCell(timeItem: entry.timeItems[2])
                TimeItemGridCell(timeItem: entry.timeItems[3])
            }
        }.padding(8)
    }
    
}

struct TimeItemGridWidget: Widget {
    let kind: String = "TimeItemGridWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: MultipleConfigurationIntent.self, provider: TimeItemGridProvider()) { entry in
            TimeItemGridEntryView(entry: entry)
            
        }
        .configurationDisplayName("Single Time Item")
        .supportedFamilies([.systemMedium, .systemLarge])
        .description("Display and quickly access one of your Time Items.")
    }
}

//struct TimeItemGridWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        TimeItemGridEntryView(entry: SingleTimeItemEntry(isPlaceholder: false, date: Date(), title: "Placeholder", totalTime: 300, remainingTime: 300, timeStarted: Date(), timeFinished: Date(), isStopwatch: false, isPaused: true, isRunning: false, uri: nil, configuration: MultipleConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
