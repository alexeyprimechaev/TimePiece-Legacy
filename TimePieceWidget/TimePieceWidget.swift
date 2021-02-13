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
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), timeItem: TimeItem(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), timeItem: TimeItem(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let context = PersistenceController.shared.container.viewContext
        let request = TimeItem.getAllTimeItems()
        
                
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            
            var results = [TimeItem]()
            
            do { results = try context.fetch(request) }
            catch let error as NSError {print("error")}
            
            print("OVER HERE")
            dump(results)
            let entry = SimpleEntry(date: entryDate, timeItem: results[0], configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let timeItem: TimeItem
    let configuration: ConfigurationIntent
}

struct TimePieceWidgetEntryView : View {
    var entry: Provider.Entry
    
    @State private var currentTime: String = "00:00"

    var body: some View {
        VStack {
            Text(entry.timeItem.title)
            if entry.timeItem.isPaused {
                Text(entry.timeItem.remainingTimeString)
            } else {
                Text(entry.timeItem.timeFinished, style: .timer)
            }
            
        }
    }
    
    func updateTime() {
        print("hmm")
        
        if entry.timeItem.isStopwatch {
            if !entry.timeItem.isPaused {
                currentTime = Date().timeIntervalSince(entry.timeItem.timeStarted).editableStringMilliseconds()
            } else {
                
            }
            
            
        } else {
            if !entry.timeItem.isPaused {
                
                
                if entry.timeItem.timeFinished.timeIntervalSince(Date()) <= 0 {
                   
                    entry.timeItem.togglePause()
                    
                    entry.timeItem.remainingTime = 0
                    
                    //AudioServicesPlaySystemSound(entry.timeItem.soundSetting == TimeItem.soundSettings[0] ? 1007 : 1036)
                    
                }
                
                currentTime = entry.timeItem.timeFinished.timeIntervalSince(Date()).editableStringMilliseconds()

       
            }
        }
        
        
        
    }
}

@main
struct TimePieceWidget: Widget {
    let kind: String = "TimePieceWidget"
    
    let context = PersistenceController.shared.container.viewContext
    let request = TimeItem.getAllTimeItems()
    
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            TimePieceWidgetEntryView(entry: entry).onAppear {
                print("wow")
                var results = [TimeItem]()
                do { results = try context.fetch(request) }
                catch let error as NSError {print("error")}
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct TimePieceWidget_Previews: PreviewProvider {
    static var previews: some View {
        TimePieceWidgetEntryView(entry: SimpleEntry(date: Date(), timeItem: TimeItem(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
