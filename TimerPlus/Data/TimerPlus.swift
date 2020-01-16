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
    
    // Main Properties
    @NSManaged public var createdAt: Date?
    @NSManaged public var isPaused: NSNumber?
    @NSManaged public var currentTime: NSNumber?
    @NSManaged public var totalTime: NSNumber?
    @NSManaged public var timeStarted: Date?
    @NSManaged public var timeFinished: Date?
    @NSManaged public var title: String?
    
    // Setting Properties
    @NSManaged public var soundSetting: String?
    @NSManaged public var precisionSetting: String?
    @NSManaged public var notificationSetting: String?
    
    // Setting Collections
    static let soundSettings = ["Short", "Long"]
    static let precisionSettings = ["Smart", "On", "Off"]
    static let notificationSettings = ["On", "Off"]
    
    // Time Formatters
    static let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "MMM dd HH:mm"
        return formatter
    }()
    static let currentTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SS"
        return formatter
    }()
    static let timeFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .none
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = .halfUp
        
        return formatter
    }()
    
    static func newTimer(totalTime: Double, title: String, context: NSManagedObjectContext) {
        let timer = TimerPlus(context: context)
        
        // User Input
        timer.title = title
        timer.totalTime = totalTime as NSNumber
        
        // Defaults
        timer.isPaused = true
        timer.currentTime = timer.totalTime
        timer.timeStarted = Date()
        timer.timeFinished = timer.timeStarted?.addingTimeInterval(timer.currentTime as! TimeInterval)
    
        // Settings
        timer.soundSetting = soundSettings[0]
        timer.precisionSetting = precisionSettings[0]
        timer.notificationSetting = notificationSettings[0]
        
        // Saving
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
