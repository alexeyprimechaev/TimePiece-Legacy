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
import AVFoundation


public class TimerItem: NSManagedObject, Identifiable {
    
//MARK: - Properties
    
    public var id: NSManagedObjectID {
        objectID
    }
    
    var logItem: LogItem?
    
    //MARK: Main Properties
    @NSManaged public var createdAtStored: Date?
    @NSManaged public var isPausedStored: NSNumber?
    @NSManaged public var isReusableStored: NSNumber?
    @NSManaged public var isRunningStored: NSNumber?
    @NSManaged public var remainingTimeStored: NSNumber?
    @NSManaged public var totalTimeStored: NSNumber?
    @NSManaged public var timeStartedStored: Date?
    @NSManaged public var timeFinishedStored: Date?
    @NSManaged public var titleStored: String?
    @NSManaged public var notificationIdentifierStored: UUID?
    
    //MARK: Setting Properties
    @NSManaged public var soundSettingStored: String?
    @NSManaged public var precisionSettingStored: String?
    @NSManaged public var notificationSettingStored: String?
    @NSManaged public var showInLogStored: NSNumber?
    
    //MARK: Setting Collections
    static let soundSettings = ["short", "long"]
    static let precisionSettings = ["on", "off", "smart"]
    static let notificationSettings = ["on", "off"]
    static let reusableSettings = ["yes", "no"]
    
    
    //MARK: Formatters
    static let createdAtFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "MMM dd HH:mm"
        return formatter
    }()
    static let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    static let currentTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    static var shortDateFormatter: RelativeDateTimeFormatter {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        formatter.unitsStyle = .full
        return formatter
    }
    static let timeFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .none
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = .halfUp
        
        return formatter
    }()
    
//MARK: - Functions
    
    var timer: Timer?
    
    //MARK: Creation (in context)
    static func newTimer(totalTime: Double, title: String, context: NSManagedObjectContext, reusableSetting: String, soundSetting: String, precisionSetting: String, notificationSetting: String, showInLog: Bool) {
        let timer = TimerItem(context: context)
        
        // User Input
        timer.title = title
        timer.totalTime = totalTime
        
        // Defaults
        timer.createdAt = Date()
        timer.isPaused = true
        timer.isRunning = false
        
        timer.remainingTime = timer.totalTime
        timer.timeStarted = Date()
        timer.timeFinished = timer.timeStarted.addingTimeInterval(timer.remainingTime)
        timer.notificationIdentifier = UUID()
    
        // Settings
        timer.isReusable.yesNo = reusableSetting
        timer.soundSetting = soundSetting
        timer.precisionSetting = precisionSetting
        timer.notificationSetting = notificationSetting
        timer.showInLog = showInLog
        
        // Saving
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    
    //MARK: Deletion (from context)
    
    func remove(from context: NSManagedObjectContext) {
        
        NotificationManager.removeDeliveredNotification(timer: self)
        NotificationManager.removePendingNotification(timer: self)
        
        context.delete(self)
    }
    
    //MARK: Toggle Pause
    func togglePause() {
        
        NotificationManager.scheduleNotification(timer: self)
        
        isRunning = true
        if isPaused {
            timeStarted = Date()
            timeFinished = timeStarted.addingTimeInterval(remainingTime)
            isPaused = false
            
            if showInLog {
                logItem = LogItem(context: self.managedObjectContext!)
                logItem?.title = title
                logItem?.timeStarted = timeStarted
                logItem?.timeFinished = timeFinished
            }
            
        } else {
            timeStarted = Date()
            remainingTime = timeFinished.timeIntervalSince(timeStarted)
            isPaused = true
            
            if showInLog {
                if remainingTime > 0 {
                    logItem?.timeFinished = Date()
                }
                logItem = nil
            }
        }
        
        try? self.managedObjectContext?.save()
    }
    
    func makeReusable() {
        isReusable = true
    }
    
    
    //MARK: Reset
    func reset() {
        
        if remainingTime <= 0 {
            NotificationManager.removeDeliveredNotification(timer: self)
        } else {
            NotificationManager.removePendingNotification(timer: self)
        }
        isRunning = false
        isPaused = true
        
        timeStarted = Date()
        remainingTime = totalTime
        timeFinished = timeStarted.addingTimeInterval(remainingTime)
        
        if showInLog {
            logItem?.timeFinished = Date()
            logItem = nil
        }
        
        try? self.managedObjectContext?.save()
    }
    

}

//MARK: - Unwrappers
extension TimerItem {
    
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
    
    var showInLog: Bool {
        get { showInLogStored?.boolValue ?? true }
        set { showInLogStored = newValue as NSNumber }
    }
    
    var remainingTime: TimeInterval {
        get { remainingTimeStored as? TimeInterval ?? 0 }
        set {
            if newValue >= 0 {
                remainingTimeStored = newValue as NSNumber
            } else {
                self.remainingTime = 0
            }
            
            
        }
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
        get { titleStored ?? " " }
        set { titleStored = newValue }
    }
    
    var notificationIdentifier: UUID {
        get { notificationIdentifierStored ?? UUID() }
        set { notificationIdentifierStored = newValue }
    }
    
    var soundSetting: String {
        get { soundSettingStored ?? TimerItem.soundSettings[0] }
        set { soundSettingStored = newValue }
    }
    
    var precisionSetting: String {
        get { precisionSettingStored ?? TimerItem.precisionSettings[0] }
        set { precisionSettingStored = newValue }
    }
    
    var notificationSetting: String {
        get { notificationSettingStored ?? TimerItem.notificationSettings[0] }
        set { notificationSettingStored = newValue }
    }
    
    //MARK: Helpers
    
    var remainingTimeString: String {
        get { remainingTime.stringFromTimeInterval(precisionSetting: precisionSetting) }
    }
    
    var totalTimeString: String {
        get { totalTime.stringFromTimeInterval(precisionSetting: precisionSetting) }
    }
    
    var editableTimeString: String {
        get { totalTime.editableString() }
        set { totalTime = newValue.stringToTimeInterval() }
    }

    
}


//MARK: - Converter Functions

extension String {
    
    func stringToTimeInterval() -> TimeInterval {
        var seconds: TimeInterval = 0
        var minutes: TimeInterval = 0
        var hours: TimeInterval = 0
        
        if self.count <= 2 {
            seconds = TimeInterval(self) ?? 0
        } else if self.count == 3 {
            seconds = TimeInterval(String(self.suffix(2))) ?? 0
            minutes = TimeInterval(String(self.prefix(1))) ?? 0
        } else if self.count == 4 {
            seconds = TimeInterval(String(self.suffix(2))) ?? 0
            minutes = TimeInterval(String(self.prefix(2))) ?? 0
        } else if self.count == 5 {
            seconds = TimeInterval(String(self.suffix(2))) ?? 0
            hours = TimeInterval(String(self.prefix(1))) ?? 0
            minutes = TimeInterval(String(String(self.prefix(3)).suffix(2))) ?? 0
        } else if self.count == 6 {
            seconds = TimeInterval(String(self.suffix(2))) ?? 0
            hours = TimeInterval(String(self.prefix(2))) ?? 0
            minutes = TimeInterval(String(String(self.prefix(4)).suffix(2))) ?? 0
        } else {
            seconds = TimeInterval(self) ?? 0
        }
        
        return seconds + (minutes*60) + (hours*3600)
    }
    
    //MARK: String to Time
    func stringToTime(showAllDigits: Bool) -> String {
        
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
        
        if !showAllDigits {
            if hours > 0 {
                return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
            } else {
                return String(format: "%0.2d:%0.2d",minutes,seconds)
            }
        } else {
            return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
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
    
    
    func relativeStringFromNumber() -> String {
        
        let time = NSInteger(self)
        
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
        
    }
    
    func editableString() -> String {
        
        let time = NSInteger(self)
        
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
        
    }
    
    
    //MARK: String From TimeInterval
    func stringFromTimeInterval(precisionSetting: String) -> String {

        let time = NSInteger(self)

        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 100)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        
        if precisionSetting == "smart" {
            if time < 60 {
                return String(format: "%0.2d.%0.2d",seconds,ms)
            } else if time<3600 {
                return String(format: "%0.2d:%0.2d",minutes,seconds)
            } else {
                return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
            }
        } else if precisionSetting == "on" {
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

extension Bool {
    var yesNo: String {
        get {
            if self {
                return "yes"
            } else {
                return "no"
            }
        }
        set {
            if newValue == "yes" {
                self = true
            } else {
                self = false
            }
        }
    }
    
    var onOff: String {
        get {
            if self {
                return "on"
            } else {
                return "off"
            }
        }
        set {
            if newValue == "on" {
                self = true
            } else {
                self = false
            }
        }
    }
}

//MARK: - CoreData
extension TimerItem {
    static func getAllTimers() -> NSFetchRequest<TimerItem> {
        let request: NSFetchRequest<TimerItem> = TimerItem.fetchRequest() as! NSFetchRequest<TimerItem>
        
        let sortDescriptor = NSSortDescriptor(key: "createdAtStored", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
}
