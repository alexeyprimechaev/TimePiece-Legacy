//
//  TimerPlus.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/5/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import Foundation
import Combine
import CoreData

public class TimerPlus: NSManagedObject, Identifiable {
    @NSManaged public var createdAt: Date?
    @NSManaged public var isPaused: NSNumber?
    @NSManaged public var currentTime: NSNumber?
    @NSManaged public var totalTime: NSNumber?
    @NSManaged public var timeStarted: Date?
    @NSManaged public var timeFinished: Date?
    @NSManaged public var title: String?
    
    static let dateFormatter = RelativeDateTimeFormatter()
    
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SS"
        return formatter
    }()
    
    static func newTimer(totalTime: Double, title: String, context: NSManagedObjectContext) {
        let timer = TimerPlus(context: context)
        
        timer.createdAt = Date()
        timer.totalTime = totalTime as NSNumber
        timer.currentTime = timer.totalTime
        timer.title = title
        timer.isPaused = true
        timer.timeStarted = Date()
        timer.timeFinished =
        timer.timeStarted?.addingTimeInterval(timer.currentTime as! TimeInterval)
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func togglePause() {
        if(self.isPaused ?? true).boolValue {
            self.timeStarted = Date()
            self.timeFinished = self.timeStarted?.addingTimeInterval(self.currentTime as! TimeInterval)
            self.isPaused = false
            
        } else {

            self.timeStarted = Date()
            self.currentTime = ((self.timeFinished ?? Date()).timeIntervalSince(self.timeStarted ?? Date())) as NSNumber
            self.isPaused = true
        }
    }
    
    func updateTime() {
        if !(self.isPaused?.boolValue ?? true
            ) {
            self.timeStarted = Date()
            self.currentTime = ((self.timeFinished ?? Date()).timeIntervalSince(self.timeStarted ?? Date())) as NSNumber
            
            if (self.currentTime?.doubleValue ?? 0 <= 0) {
                self.currentTime = self.totalTime
                self.timeStarted = Date()
                self.timeFinished = self.timeStarted?.addingTimeInterval(self.currentTime as! TimeInterval)
                self.isPaused = true
            }

            
            
        }
    }

}

extension TimerPlus {
    static func getAllTimers() -> NSFetchRequest<TimerPlus> {
        let request: NSFetchRequest<TimerPlus> = TimerPlus.fetchRequest() as! NSFetchRequest<TimerPlus>
        
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
}
