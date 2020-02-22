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
import UserNotifications

public class TimerPlus: NSManagedObject, Identifiable {
    
//MARK: - Properties
    
    
    
    //MARK: Main Properties
    @NSManaged public var createdAtStored: Date?
    @NSManaged public var isPausedStored: NSNumber?
    @NSManaged public var isReusableStored: NSNumber?
    @NSManaged public var isRunningStored: NSNumber?
    @NSManaged public var currentTimeStored: NSNumber?
    @NSManaged public var totalTimeStored: NSNumber?
    @NSManaged public var timeStartedStored: Date?
    @NSManaged public var timeFinishedStored: Date?
    @NSManaged public var titleStored: String?
    @NSManaged public var notificationIdentifierStored: UUID?
    
    //MARK: Setting Properties
    @NSManaged public var soundSettingStored: String?
    @NSManaged public var precisionSettingStored: String?
    @NSManaged public var notificationSettingStored: String?
    
    //MARK: Setting Collections
    static let soundSettings = ["Short", "Long"]
    static let precisionSettings = ["On", "Off", "Smart"]
    static let notificationSettings = ["On", "Off"]
    
    
    //MARK: Formatters
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
    
//MARK: - Functions
    
    
    
    //MARK: Creation (in context)
    static func newTimer(totalTime: Double, title: String, context: NSManagedObjectContext) {
        let timer = TimerPlus(context: context)
        
        // User Input
        timer.title = title
        timer.totalTime = totalTime
        
        // Defaults
        timer.createdAt = Date()
        timer.isPaused = true
        timer.isRunning = false
        timer.isReusable = false
        timer.currentTime = timer.totalTime
        timer.timeStarted = Date()
        timer.timeFinished = timer.timeStarted.addingTimeInterval(timer.currentTime)
        timer.notificationIdentifier = UUID()
    
        // Settings
        timer.soundSetting = soundSettings[0]
        timer.precisionSetting = precisionSettings[1]
        timer.notificationSetting = notificationSettings[0]
        
        // Saving
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    
    //MARK: Toggle Pause
    func togglePause() {
        
        NotificationManager.scheduleNotification(timer: self)
        
        isRunning = true
        if isPaused {
            timeStarted = Date()
            timeFinished = timeStarted.addingTimeInterval(currentTime)
            isPaused = false
            
        } else {
            timeStarted = Date()
            currentTime = timeFinished.timeIntervalSince(timeStarted)
            isPaused = true
        }
    }
    
    
    //MARK: Reset
    func reset() {
        
        if currentTime <= 0 {
            print(NotificationManager.badgeCount)
            NotificationManager.removeDeliveredNotification(timer: self)
        }
        isRunning = false
        isPaused = true
        timeStarted = Date()
        currentTime = totalTime
        timeFinished = timeStarted.addingTimeInterval(currentTime)
    }
    
    
    //MARK: Update time
    func updateTime() {
        if !isPaused {
            timeStarted = Date()
            currentTime = timeFinished.timeIntervalSince(timeStarted)
            
            if currentTime <= 0 {
               
                self.togglePause()
                currentTime = 0
            }
   
        }
    }

}

//MARK: - Unwrappers
extension TimerPlus {
    var createdAt: Date {
        get { createdAtStored ?? Date() }
        set { createdAtStored = newValue }
    }
    
    var isPaused: Bool {
        get { isPausedStored?.boolValue ?? true }
        set { isPausedStored = newValue as NSNumber }
    }
    
    var isRunning: Bool {
        get { isRunningStored?.boolValue ?? true }
        set { isRunningStored = newValue as NSNumber }
    }
    
    var isReusable: Bool {
        get { isReusableStored?.boolValue ?? true }
        set { isReusableStored = newValue as NSNumber }
    }
    
    var currentTime: TimeInterval {
        get { currentTimeStored as? TimeInterval ?? 0 }
        set { currentTimeStored = newValue as NSNumber }
    }
    
    var totalTime: TimeInterval {
        get { totalTimeStored as? TimeInterval ?? 0 }
        set { totalTimeStored = newValue as NSNumber }
    }
    
    var timeStarted: Date {
        get { timeStartedStored ?? Date() }
        set { timeStartedStored = newValue }
    }
    
    var timeFinished: Date {
        get { timeFinishedStored ?? Date() }
        set { timeFinishedStored = newValue }
    }
    
    var title: String {
        get { titleStored ?? "Found Nil" }
        set { titleStored = newValue }
    }
    
    var notificationIdentifier: UUID {
        get { notificationIdentifierStored ?? UUID() }
        set { notificationIdentifierStored = newValue }
    }
    
    var soundSetting: String {
        get { soundSettingStored ?? TimerPlus.soundSettings[0] }
        set { soundSettingStored = newValue }
    }
    
    var precisionSetting: String {
        get { precisionSettingStored ?? TimerPlus.precisionSettings[0] }
        set { precisionSettingStored = newValue }
    }
    
    var notificationSetting: String {
        get { notificationSettingStored ?? TimerPlus.notificationSettings[0] }
        set { notificationSettingStored = newValue }
    }
}


//MARK: - Converter Functions

extension String {
    
    //MARK: String to Time
    func stringToTime() -> String {
        
        var seconds = 0
        var minutes = 0
        var hours = 0
        
        if self.count <= 2 {
            seconds = Int(self) ?? 0
        } else if self.count == 3 {
            seconds = Int(String(self.suffix(2))) ?? 0
            minutes = Int(String(self.prefix(1))) ?? 0
        } else if self.count == 4 {
            seconds = Int(String(self.suffix(2))) ?? 0
            minutes = Int(String(self.prefix(2))) ?? 0
        } else if self.count == 5 {
            seconds = Int(String(self.suffix(2))) ?? 0
            hours = Int(String(self.prefix(1))) ?? 0
            minutes = Int(String(String(self.prefix(3)).suffix(2))) ?? 0
        } else if self.count == 6 {
            seconds = Int(String(self.suffix(2))) ?? 0
            hours = Int(String(self.prefix(2))) ?? 0
            minutes = Int(String(String(self.prefix(4)).suffix(2))) ?? 0
        } else {
            seconds = Int(self) ?? 0
        }
        
        if hours > 0 {
            return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
        } else {
            return String(format: "%0.2d:%0.2d",minutes,seconds)
        }
    }
    
    
    //MARK: Calculate Time
    func calculateTime() -> TimeInterval {
        var value: TimeInterval
        
        var seconds = 0
        var minutes = 0
        var hours = 0
        
        if self.count <= 2 {
            seconds = Int(self) ?? 0
        } else if self.count == 3 {
            seconds = Int(String(self.suffix(2))) ?? 0
            minutes = Int(String(self.prefix(1))) ?? 0
        } else if self.count == 4 {
            seconds = Int(String(self.suffix(2))) ?? 0
            minutes = Int(String(self.prefix(2))) ?? 0
        } else if self.count == 5 {
            seconds = Int(String(self.suffix(2))) ?? 0
            hours = Int(String(self.prefix(1))) ?? 0
            minutes = Int(String(String(self.prefix(3)).suffix(2))) ?? 0
        } else if self.count == 6 {
            seconds = Int(String(self.suffix(2))) ?? 0
            hours = Int(String(self.prefix(2))) ?? 0
            minutes = Int(String(String(self.prefix(4)).suffix(2))) ?? 0
        } else {
            seconds = Int(self) ?? 0
        }

        value = TimeInterval(seconds + 60*minutes + 3600*hours)
        
        return value
    }
}

extension TimeInterval {
    
    //MARK: String From Number
    func stringFromNumber() -> String {
        
        let time = NSInteger(self)
        
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        if hours > 0 {
            return String(format: "%0.2d%0.2d%0.2d",hours,minutes,seconds)
        } else if (minutes>0) {
            return String(format: "%0.2d%0.2d",minutes,seconds)
        } else {
            return String(format: "%0.2d",seconds)
        }
    }
    
    
    //MARK: String From TimeInterval
    func stringFromTimeInterval(precisionSetting: String) -> String {

        let time = NSInteger(self)

        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 100)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        
        if precisionSetting == "Smart" {
            if time < 60 {
                return String(format: "%0.2d.%0.2d",seconds,ms)
            } else if time<3600 {
                return String(format: "%0.2d:%0.2d",minutes,seconds)
            } else {
                return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
            }
        } else if precisionSetting == "On" {
            if time < 60 {
                return String(format: "%0.2d.%0.2d",seconds,ms)
            } else if time<3600 {
                return String(format: "%0.2d:%0.2d.%0.2d",minutes,seconds,ms)
            } else {
                return String(format: "%0.2d:%0.2d:%0.2d.%0.2d",hours,minutes,seconds,ms)
            }
        } else {
            if time < 60 {
                return String(format: "%0.2d:%0.2d",minutes,seconds)
            } else if time<3600 {
                return String(format: "%0.2d:%0.2d",minutes,seconds)
            } else {
                return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
            }
        }

    }
}


//MARK: - CoreData
extension TimerPlus {
    static func getAllTimers() -> NSFetchRequest<TimerPlus> {
        let request: NSFetchRequest<TimerPlus> = TimerPlus.fetchRequest() as! NSFetchRequest<TimerPlus>
        
        let sortDescriptor = NSSortDescriptor(key: "createdAtStored", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
}
