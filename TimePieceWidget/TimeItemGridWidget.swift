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

enum ItemKind {
    case placeholder, normal, new
}

struct SingleTimeItem {
    
    var isFinished = false
    
    let kind: ItemKind
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

let placeholderSingleTimeItem = SingleTimeItem(kind: .placeholder, date: Date(), title: "Placeholder", totalTime: 300, remainingTime: 300, timeStarted: Date(), timeFinished: Date(), isStopwatch: false, isPaused: true, isRunning: false, uri: nil)
let newSingleTimeItem = SingleTimeItem(kind: .new, date: Date(), title: "Placeholder", totalTime: 300, remainingTime: 300, timeStarted: Date(), timeFinished: Date(), isStopwatch: false, isPaused: true, isRunning: false, uri: nil)

func fillWithPlaceholders(fill timeItems: [SingleTimeItem], toCount: Int) -> [SingleTimeItem] {
    
    var newTimeItems = timeItems
    
    if newTimeItems.count > toCount {
        newTimeItems = Array(timeItems[...toCount])
    } else if newTimeItems.count < toCount {
        newTimeItems.append(newSingleTimeItem)
        var i = newTimeItems.count
        while i < toCount {
            newTimeItems.append(placeholderSingleTimeItem)
            i += 1
        }
    }
    
    return newTimeItems
    
}

struct TimeItemGridProvider: IntentTimelineProvider {
    
    func fetchTimeItems(configuration: MultipleConfigurationIntent) -> [SingleTimeItem] {
        let context = PersistenceController.shared.container.viewContext
        let request = TimeItem.getAllTimeItems()
        
        var results = [TimeItem]()
        
        do { results = try context.fetch(request) }
        catch let error as NSError {print("error")}
        
        
        var timeItems = [SingleTimeItem]()
        
        
        
        switch configuration.timeItemGroup {
        case .running:
            for item in results {
                let timeItem = SingleTimeItem(isFinished: false, kind: .normal, date: Date(), title: item.title, totalTime: item.totalTime, remainingTime: item.remainingTime, timeStarted: item.timeStarted, timeFinished: item.timeFinished, isStopwatch: item.isStopwatch, isPaused: item.isPaused, isRunning: item.isRunning, uri: item.objectID.uriRepresentation().absoluteString)
                
                if timeItem.isRunning {
                    timeItems.append(timeItem)
                }
            }
        case .unknown:
            for item in results {
                let timeItem = SingleTimeItem(isFinished: false, kind: .normal, date: Date(), title: item.title, totalTime: item.totalTime, remainingTime: item.remainingTime, timeStarted: item.timeStarted, timeFinished: item.timeFinished, isStopwatch: item.isStopwatch, isPaused: item.isPaused, isRunning: item.isRunning, uri: item.objectID.uriRepresentation().absoluteString)
                timeItems.append(timeItem)
            }
            
            timeItems.sort {
                $0.timeStarted > $1.timeStarted
            }
        case .recent:
            for item in results {
                let timeItem = SingleTimeItem(isFinished: false, kind: .normal, date: Date(), title: item.title, totalTime: item.totalTime, remainingTime: item.remainingTime, timeStarted: item.timeStarted, timeFinished: item.timeFinished, isStopwatch: item.isStopwatch, isPaused: item.isPaused, isRunning: item.isRunning, uri: item.objectID.uriRepresentation().absoluteString)
                timeItems.append(timeItem)
            }
            
            timeItems.sort {
                $0.timeStarted > $1.timeStarted
            }
        }
        
        return timeItems
    }
    
    let placeholderMultipleTimeItems = MultipleTimeItemsEntry(date: Date(), timeItems: [placeholderSingleTimeItem,placeholderSingleTimeItem,placeholderSingleTimeItem,placeholderSingleTimeItem], configuration: MultipleConfigurationIntent())
    
    
    func provideTimeItemsWithConfig(date: Date, configuration: MultipleConfigurationIntent) -> [MultipleTimeItemsEntry] {
        
        
        
        var timeItems = fetchTimeItems(configuration: configuration)
        
        var entries = [MultipleTimeItemsEntry]()
        
        entries.append(MultipleTimeItemsEntry(date: date, timeItems: timeItems, configuration: configuration))
        
        timeItems.sort {
            $0.timeFinished < $1.timeFinished
        }
        
        
        // Start mapping entries to their respective dates
        if timeItems.count > 0 {
            for i in 0...timeItems.count-1 {
                
                var tempTimeItems = timeItems
                
                // Mark all timers that should have finished before or simultaniously with timeItem[i] as finished
                for j in 0...i {
                    if tempTimeItems[j].isRunning {
                        tempTimeItems[j].isFinished = true
                    }
                }
                
                // Return the array to its initial sorting
                
                tempTimeItems.sort {
                    $0.timeStarted > $1.timeStarted
                }
                
                
                // Append entry for each timer finish (each entry containing finishes for all preceding timers)
                entries.append(MultipleTimeItemsEntry(date: timeItems[i].timeFinished, timeItems: tempTimeItems, configuration: configuration))
            }
        }
        
        
        
        
        return entries
        
        
        
        
        
    }
    
    
    
    func placeholder(in context: Context) -> MultipleTimeItemsEntry {
        return provideTimeItemsWithConfig(date: Date(), configuration: MultipleConfigurationIntent())[0]
    }
    
    func getSnapshot(for configuration: MultipleConfigurationIntent, in context: Context, completion: @escaping (MultipleTimeItemsEntry) -> ()) {
        completion(provideTimeItemsWithConfig(date: Date(), configuration: MultipleConfigurationIntent())[0])
    }
    
    func getTimeline(for configuration: MultipleConfigurationIntent, in context: Context, completion: @escaping (Timeline<MultipleTimeItemsEntry>) -> ()) {
        
        var entries: [MultipleTimeItemsEntry] = []
        
        entries = provideTimeItemsWithConfig(date: Date(), configuration: configuration)
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}


struct TimeItemGridCell: View {
    
    @State var timeItem: SingleTimeItem
    
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        Group {
            switch timeItem.kind {
            case .normal:
                Link(destination: timeItem.url ?? URL(string: "https://apple.com")!) {
                    VStack(alignment: .leading) {
                        if timeItem.isStopwatch {
                            if timeItem.isRunning {
                                if timeItem.isPaused {
                                    Text(timeItem.remainingTime.stringFromNumber()).opacity(0.5)
                                } else {
                                    Text(timeItem.timeStarted, style: .timer).opacity(0.5).multilineTextAlignment(.leading)
                                }
                            } else {
                                Text("Start").opacity(0.5)
                            }
                            Text(timeItem.title.isEmpty ? "Stopwatch ⏱" : LocalizedStringKey(timeItem.title)).lineLimit(1)
                        } else {
                            Text(timeItem.title.isEmpty ? "Timer ⏱" : LocalizedStringKey(timeItem.title)).lineLimit(2)
                            if timeItem.isPaused {
                                if timeItem.remainingTime == 0 {
                                    Text("Done").multilineTextAlignment(.leading).opacity(0.5)
                                } else {
                                    Text(timeItem.remainingTime.stringFromNumber()).opacity(0.5)
                                }
                            } else {
                                if timeItem.isFinished {
                                    Text("Done").multilineTextAlignment(.leading).opacity(0.5)
                                } else {
                                    Text(timeItem.timeFinished, style: .timer).multilineTextAlignment(.leading).opacity(0.5)
                                }
                                
                            }
                        }
                        
                    }.padding(.horizontal, 14).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading).background(ContainerRelativeShape().foregroundColor(Color(.systemGroupedBackground)))
                }
            case .new:
                Link(destination: URL(string: "timepiece://newtimeitem")!) {
                    VStack(alignment: .leading) {
                        Label {
                            Text("New")
                        } icon: {
                            Image(systemName: "plus")
                        }
                    }.padding(.horizontal, 14).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading).background(ContainerRelativeShape().foregroundColor(Color(.systemGroupedBackground)))
                }
            case .placeholder:
                VStack(alignment: .leading) {
                    Label {
                        Text("")
                    } icon: {
                        Image(systemName: "")
                    }
                }.padding(.horizontal, 14).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading).opacity(0)
            }
        }.font(.footnote.bold())
        
        
    }
    
}

struct TimeItemGridEntryView: View {
    
    var entry: TimeItemGridProvider.Entry
    
    @EnvironmentObject var settings: Settings
    
    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        
        
        switch family {
        case .systemMedium:
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    TimeItemGridCell(timeItem: fillWithPlaceholders(fill: entry.timeItems, toCount: 4)[0])
                    TimeItemGridCell(timeItem: fillWithPlaceholders(fill: entry.timeItems, toCount: 4)[1])
                }
                HStack(spacing: 8) {
                    TimeItemGridCell(timeItem: fillWithPlaceholders(fill: entry.timeItems, toCount: 4)[2])
                    TimeItemGridCell(timeItem: fillWithPlaceholders(fill: entry.timeItems, toCount: 4)[3])
                }
            }.padding(8)
        case .systemLarge:
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    TimeItemGridCell(timeItem: fillWithPlaceholders(fill: entry.timeItems, toCount: 8)[0])
                    TimeItemGridCell(timeItem: fillWithPlaceholders(fill: entry.timeItems, toCount: 8)[1])
                }
                HStack(spacing: 8) {
                    TimeItemGridCell(timeItem: fillWithPlaceholders(fill: entry.timeItems, toCount: 8)[2])
                    TimeItemGridCell(timeItem: fillWithPlaceholders(fill: entry.timeItems, toCount: 8)[3])
                }
                HStack(spacing: 8) {
                    TimeItemGridCell(timeItem: fillWithPlaceholders(fill: entry.timeItems, toCount: 8)[4])
                    TimeItemGridCell(timeItem: fillWithPlaceholders(fill: entry.timeItems, toCount: 8)[5])
                }
                HStack(spacing: 8) {
                    TimeItemGridCell(timeItem: fillWithPlaceholders(fill: entry.timeItems, toCount: 8)[6])
                    TimeItemGridCell(timeItem: fillWithPlaceholders(fill: entry.timeItems, toCount: 8)[7])
                }
            }.padding(8)
        default:
            Text("Some other WidgetFamily in the future.")
        }
        
        
    }
    
}

struct TimeItemGridWidget: Widget {
    let kind: String = "TimeItemGridWidget"
    
    @ObservedObject var settings = Settings()
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: MultipleConfigurationIntent.self, provider: TimeItemGridProvider()) { entry in
            TimeItemGridEntryView(entry: entry).environmentObject(settings)
            
        }
        .configurationDisplayName("Multiple Timers")
        .supportedFamilies([.systemMedium, .systemLarge])
        .description("Display and quickly access several of your Timers or Stopwatches")
    }
}

//struct TimeItemGridWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        TimeItemGridEntryView(entry: SingleTimeItemEntry(isPlaceholder: false, date: Date(), title: "Placeholder", totalTime: 300, remainingTime: 300, timeStarted: Date(), timeFinished: Date(), isStopwatch: false, isPaused: true, isRunning: false, uri: nil, configuration: MultipleConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
