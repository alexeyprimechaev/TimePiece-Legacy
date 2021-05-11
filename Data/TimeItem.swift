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
import WidgetKit


public class TimeItemPlaceholder: TimeItem {
    static let object = TimeItemPlaceholder()
}

public class TimeItem: NSManagedObject, Identifiable {
    
    //MARK: - Properties
    
    public var id: NSManagedObjectID {
        objectID
    }
    
    @objc(addLogItemObject:)
    @NSManaged public func addToLogItem(_ value: LogItem)
    
    @objc(removeLogItemObject:)
    @NSManaged public func removeFromLogItem(_ value: LogItem)
    
    @objc(addLogItem:)
    @NSManaged public func addToLogItem(_ values: NSSet)
    
    @objc(removeLogItem:)
    @NSManaged public func removeFromLogItem(_ values: NSSet)
    
    @NSManaged private var orderStored: NSNumber?
    
    var logItemOld: LogItem?
    
    //MARK: Main Properties
    @NSManaged private var createdAtStored: Date?
    @NSManaged private var isStopwatchStored: NSNumber?
    @NSManaged private var isPausedStored: NSNumber?
    @NSManaged private var isReusableStored: NSNumber?
    @NSManaged private var isRunningStored: NSNumber?
    @NSManaged private var remainingTimeStored: NSNumber?
    @NSManaged private var totalTimeStored: NSNumber?
    @NSManaged private var timeStartedStored: Date?
    @NSManaged private var timeFinishedStored: Date?
    @NSManaged private var titleStored: String?
    @NSManaged private var notificationIdentifierStored: UUID?
    @NSManaged private var logItem: NSSet?
    
    //MARK: Setting Properties
    @NSManaged private var soundSettingStored: String?
    @NSManaged private var precisionSettingStored: String?
    @NSManaged private var notificationSettingStored: String?
    @NSManaged private var showInLogStored: NSNumber?
    
    //MARK: Setting Collections
    static let soundSettings = ["short", "long"]
    static let precisionSettings = ["off", "on", "smart"]
    static let notificationSettings = ["off", "on"]
    static let reusableSettings = ["no", "yes"]
    
    
    //MARK: Formatters
    static let createdAtFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "MMM dd HH:mm"
        return formatter
    }()
    static let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        formatter.doesRelativeDateFormatting = false
        return formatter
    }()
    static let monthFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "MMM YYYY"
        formatter.doesRelativeDateFormatting = false
        return formatter
    }()
    static let yearFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        formatter.doesRelativeDateFormatting = false
        return formatter
    }()
    static let weekFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "w Y"
        formatter.doesRelativeDateFormatting = false
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
    
    
    //MARK: Creation (in context)
    static func newTimeItem(totalTime: Double, title: String, context: NSManagedObjectContext, reusableSetting: String, soundSetting: String, precisionSetting: String, notificationSetting: String, showInLog: Bool, isStopwatch: Bool, order: Int) -> TimeItem {
        let timeItem = TimeItem(context: context)
        
        // User Input
        timeItem.title = title
        timeItem.totalTime = totalTime
        
        timeItem.order = order
        
        // Defaults
        timeItem.createdAt = Date()
        timeItem.isPaused = true
        timeItem.isRunning = false
        
        timeItem.remainingTime = timeItem.totalTime
        timeItem.timeStarted = Date()
        timeItem.timeFinished = timeItem.timeStarted.addingTimeInterval(timeItem.remainingTime)
        timeItem.notificationIdentifier = UUID()
        
        // Settings
        timeItem.isReusable.yesNo = reusableSetting
        timeItem.soundSetting = soundSetting
        timeItem.precisionSetting = precisionSetting
        timeItem.notificationSetting = notificationSetting
        timeItem.showInLog = showInLog
        timeItem.isStopwatch = isStopwatch
        
        // Saving
        do {
            try context.save()
        } catch {
            print(error)
        }
        
        WidgetCenter.shared.reloadAllTimelines()
        return timeItem
    }
    
    
    //MARK: Deletion (from context)
    
    func remove(from context: NSManagedObjectContext) {
        
        NotificationManager.removeDeliveredNotification(timer: self)
        NotificationManager.removePendingNotification(timer: self)
        
        context.delete(self)
        
        try? context.save()
    }
    
    //MARK: Toggle Pause
    func togglePause() {
        
        if isStopwatch {
            if isRunning {
                if isPaused {
                    isRunning = true
                    isPaused = false
                    timeStarted = Date().addingTimeInterval(-remainingTime)
                } else {
                    timeFinished = Date()
                    remainingTime = timeFinished.timeIntervalSince(timeStarted)
                    isPaused = true
                }
                recordLog()
            } else {
                if isPaused {
                    isRunning = true
                    isPaused = false
                    timeStarted = Date()
                } else {
                    timeFinished = Date()
                    remainingTime = timeFinished.timeIntervalSince(timeStarted)
                    isPaused = true
                }
                recordLog()
            }
            
            
            
        } else {
            
            NotificationManager.scheduleNotification(timeItem: self)
            
            if isPaused {
                isRunning = true
                isPaused = false
                
                
                timeStarted = Date()
                
                timeFinished = timeStarted.addingTimeInterval(remainingTime)
                
                
            } else {
                timeStarted = Date()
                remainingTime = timeFinished.timeIntervalSince(timeStarted)
                isPaused = true
            }
            
            recordLog()
            
        }
        
        try? self.managedObjectContext?.save()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func recordLog() {
        if !isPaused {
            if showInLog {
                if Date().timeIntervalSince(logItems.last?.timeStarted ?? Date().addingTimeInterval(-120)) < 60 {
                    logItems.last?.timeFinished = timeFinished
                    logItems.last?.isDone = false
                    logItems.last?.origin = self
                    logItems.last?.isStopwatch = isStopwatch
                } else {
                    let logItemOwned = LogItem(context: self.managedObjectContext!)
                    logItemOwned.title = title
                    logItemOwned.timeStarted = Date()
                    logItemOwned.timeFinished = timeFinished
                    logItemOwned.isStopwatch = isStopwatch
                    logItemOwned.isDone = false
                    logItemOwned.origin = self
                }
            }
        } else {
            
            if remainingTime > 0 {
                logItems.last?.timeFinished = Date()
            }
            logItems.last?.isDone = true
        }
        print("uhuhu")
        print(logItems.count)
        dump(logItems)
    }
    
    func makeReusable() {
        isReusable = true
    }
    
    func convertToStopwatch() {
        isStopwatch = true
        precisionSetting = TimeItem.precisionSettings[0]
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
            logItems.last?.timeFinished = Date()
            logItems.last?.isDone = true
        }
        
        try? self.managedObjectContext?.save()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    
}

//MARK: - Unwrappers
extension TimeItem {
    
    var order: Int {
        get { orderStored?.intValue ?? 0 }
        set { orderStored = NSNumber(value: newValue) }
    }
    
    var createdAt: Date {
        get { createdAtStored ?? Date() }
        set { createdAtStored = newValue }
    }
    
    var isStopwatch: Bool {
        get { isStopwatchStored?.boolValue ?? false }
        set { isStopwatchStored = newValue as NSNumber }
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
        get { soundSettingStored ?? TimeItem.soundSettings[0] }
        set { soundSettingStored = newValue }
    }
    
    var precisionSetting: String {
        get { precisionSettingStored ?? TimeItem.precisionSettings[0] }
        set { precisionSettingStored = newValue }
    }
    
    var notificationSetting: String {
        get { notificationSettingStored ?? TimeItem.notificationSettings[1] }
        set { notificationSettingStored = newValue }
    }
    
    
    //MARK: Helpers
    
    var remainingTimeString: String {
        get { remainingTime.editableStringMilliseconds() }
    }
    
    var totalTimeString: String {
        get { totalTime.stringFromTimeInterval(precisionSetting: precisionSetting) }
    }
    
    var editableTimeString: String {
        get { totalTime.editableString() }
        set {
            totalTime = newValue.stringToTimeInterval()
            remainingTime = newValue.stringToTimeInterval()
        }
    }
    
    var logItems: [LogItem] {
        let set = logItem as? Set<LogItem> ?? []
        
        
        return set.sorted {
            $0.timeStarted < $1.timeStarted
        }
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
            if hours > 9 {
                return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
            } else {
                return String(format: "%0.1d:%0.2d:%0.2d",hours,minutes,seconds)

            }
        } else {
            if minutes > 9 {
                return String(format: "%0.2d:%0.2d",minutes,seconds)
            } else {
                return String(format: "%0.1d:%0.2d",minutes,seconds)
            }
        }
    }
    
    
    func relativeStringFromNumber() -> String {
        
        let time = NSInteger(self)
        
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        return hours == 0 ? minutes == 0 ? String(format: "%0.2ds",seconds) : String(format: "%0.2dm",minutes) : String(format: "%0.2dh %0.2dm",hours,minutes)
        
    }
    
    func editableString() -> String {
        
        let time = NSInteger(self)
        
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        
        return String(format: "%0.2d%0.2d%0.2d",hours,minutes,seconds)
        
    }
    
    func editableStringMilliseconds() -> String {
        
        let time = NSInteger(self)
        
        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 100)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        
        
        return String(format: "%0.2d%0.2d%0.2d%0.2d",hours,minutes,seconds,ms)
        
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
extension TimeItem {
    static func getAllTimeItems() -> NSFetchRequest<TimeItem> {
        let request: NSFetchRequest<TimeItem> = TimeItem.fetchRequest() as! NSFetchRequest<TimeItem>
        
        let sortDescriptor = NSSortDescriptor(keyPath: \TimeItem.orderStored, ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
}
