//
//  TimePieceWidget.swift
//  TimePieceWidget
//
//  Created by Alexey Primechaev on 2/13/21.
//  Copyright © 2021 Alexey Primechaev. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData

struct Provider: IntentTimelineProvider {
    
    let placeholderWidgetTimeItem = WidgetTimeItem(isPlaceholder: true, date: Date(), title: "Placeholder", totalTime: 300, remainingTime: 300, timeStarted: Date(), timeFinished: Date(), isStopwatch: false, isPaused: true, isRunning: false, uri: nil, configuration: ConfigurationIntent())
    
    func fetchTimeItem() -> WidgetTimeItem {
        let context = PersistenceController.shared.container.viewContext
        let request = TimeItem.getAllTimeItems()
        
        var results = [TimeItem]()
        
        do { results = try context.fetch(request) }
        catch let error as NSError {print("error")}
        
        if !results.isEmpty {
            return WidgetTimeItem(isPlaceholder: false, date: Date(), title: results[0].title, totalTime: results[0].totalTime, remainingTime: results[0].remainingTime, timeStarted: results[0].timeStarted, timeFinished: results[0].timeFinished, isStopwatch: results[0].isStopwatch, isPaused: results[0].isPaused, isRunning: results[0].isRunning, uri: nil, configuration: ConfigurationIntent())
        } else {
            return placeholderWidgetTimeItem
        }
        
    }
    
    func fetchTimeItemWithConfig(date: Date, configuration: ConfigurationIntent) -> [WidgetTimeItem] {
        let context = PersistenceController.shared.container.viewContext
        let request = TimeItem.getAllTimeItems()
        
        var results = [TimeItem]()
        
        do { results = try context.fetch(request) }
        catch let error as NSError {print("error")}
        
        guard let identifier = configuration.timeItem?.identifier, let timeItem = results.first(where: { item in
            item.notificationIdentifier.uuidString == identifier
        }) else {
            return [placeholderWidgetTimeItem]
        }
        
        return [
                WidgetTimeItem(isPlaceholder: false, date: Date(), title: timeItem.title, totalTime: timeItem.totalTime, remainingTime: timeItem.remainingTime, timeStarted: timeItem.timeStarted, timeFinished: timeItem.timeFinished, isStopwatch: timeItem.isStopwatch, isPaused: timeItem.isPaused, isRunning: timeItem.isRunning, uri: timeItem.objectID.uriRepresentation().absoluteString, configuration: ConfigurationIntent()),
                
            WidgetTimeItem(isFinished: true, isPlaceholder: false, date: timeItem.timeFinished, title: timeItem.title, totalTime: timeItem.totalTime, remainingTime: timeItem.remainingTime, timeStarted: timeItem.timeStarted, timeFinished: timeItem.timeFinished, isStopwatch: timeItem.isStopwatch, isPaused: timeItem.isPaused, isRunning: timeItem.isRunning, uri: timeItem.objectID.uriRepresentation().absoluteString, configuration: ConfigurationIntent())
        ]
        

        
    }
    
    
    
    func placeholder(in context: Context) -> WidgetTimeItem {
        return fetchTimeItem()
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (WidgetTimeItem) -> ()) {
        completion(fetchTimeItem())
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        var entries: [WidgetTimeItem] = []
        
        let currentDate = Date()
                
        entries.append(contentsOf: fetchTimeItemWithConfig(date: currentDate, configuration: configuration))

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct WidgetTimeItem: TimelineEntry {
    
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
    
    let configuration: ConfigurationIntent
}

struct TimePieceWidgetEntryView : View {
    var entry: Provider.Entry
    
    @State private var currentTime: String = "00:00"

    var body: some View {
            VStack(alignment: .leading) {
                if entry.isPlaceholder {
                    Text("Edit Widget")
                    Text("To Select").opacity(0.5)
                } else {
                    
                    if entry.isStopwatch {
                            if entry.isRunning {
                                if entry.isPaused {
                                    Text(entry.remainingTime.stringFromTimeInterval(precisionSetting: TimeItem.precisionSettings[1])).opacity(0.5)
                                } else {
                                    Text(entry.timeStarted, style: .timer).opacity(0.5).multilineTextAlignment(.leading)
                                }
                            } else {
                                Text("Start").opacity(0.5)
                            }
                        Text(entry.title.isEmpty ? "Stopwatch ⏱" : LocalizedStringKey(entry.title)).lineLimit(1)
                    } else {
                        Text(entry.title.isEmpty ? "Timer ⏱" : LocalizedStringKey(entry.title)).lineLimit(2)
                            if entry.isPaused {
                                if entry.remainingTime == 0 {
                                    Text("Done").multilineTextAlignment(.leading).opacity(0.5)
                                } else {
                                    Text(entry.remainingTime.stringFromTimeInterval(precisionSetting: TimeItem.precisionSettings[1])).opacity(0.5)
                                }
                            } else {
                                if entry.isFinished {
                                    Text("Done").multilineTextAlignment(.leading).opacity(0.5)
                                } else {
                                    Text(entry.timeFinished, style: .timer).multilineTextAlignment(.leading).opacity(0.5)
                                }
                                
                            }
                    }
                    
                }
               
                
            }.font(.title.bold().monospacedDigit()).padding(5).widgetURL(entry.url)
    }
    
}

@main
struct TimePieceWidget: Widget {
    let kind: String = "TimePieceWidget"
    
    let context = PersistenceController.shared.container.viewContext
    let request = TimeItem.getAllTimeItems()
    
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            TimePieceWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Single Time Item")
        .supportedFamilies([.systemSmall, .systemMedium])
        .description("Display and quickly access one of your Time Items.")
    }
}

struct TimePieceWidget_Previews: PreviewProvider {
    static var previews: some View {
        TimePieceWidgetEntryView(entry: WidgetTimeItem(isPlaceholder: false, date: Date(), title: "Placeholder", totalTime: 300, remainingTime: 300, timeStarted: Date(), timeFinished: Date(), isStopwatch: false, isPaused: true, isRunning: false, uri: nil, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
