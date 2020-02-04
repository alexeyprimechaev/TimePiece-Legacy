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
    
//MARK: - Properties
    
    
    
    //MARK: Main Properties
    @NSManaged public var createdAt: Date?
    @NSManaged public var isPaused: NSNumber?
    @NSManaged public var isRunning: NSNumber?
    @NSManaged public var currentTime: NSNumber?
    @NSManaged public var totalTime: NSNumber?
    @NSManaged public var timeStarted: Date?
    @NSManaged public var timeFinished: Date?
    @NSManaged public var title: String?
    
    //MARK: Setting Properties
    @NSManaged public var soundSetting: String?
    @NSManaged public var precisionSetting: String?
    @NSManaged public var notificationSetting: String?
    
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
        timer.totalTime = totalTime as NSNumber
        
        // Defaults
        timer.createdAt = Date()
        timer.isPaused = true
        timer.isRunning = false
        timer.currentTime = timer.totalTime
        timer.timeStarted = Date()
        timer.timeFinished = timer.timeStarted?.addingTimeInterval(timer.currentTime as! TimeInterval)
    
        // Settings
        timer.soundSetting = soundSettings[0]
        timer.precisionSetting = precisionSettings[2]
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
        isRunning = true
        if isPausedOpt {
            timeStartedOpt = Date()
            timeFinishedOpt = timeStartedOpt.addingTimeInterval(currentTimeOpt)
            isPausedOpt = false
            
        } else {
            timeStartedOpt = Date()
            currentTimeOpt = timeFinishedOpt.timeIntervalSince(timeStartedOpt)
            isPausedOpt = true
        }
    }
    
    
    //MARK: Reset
    func reset() {
        isRunningOpt = false
        isPausedOpt = true
        timeStartedOpt = Date()
        currentTimeOpt = totalTimeOpt
        timeFinishedOpt = timeStartedOpt.addingTimeInterval(currentTimeOpt)
    }
    
    
    //MARK: Update time
    func updateTime() {
        if !isPausedOpt {
            timeStartedOpt = Date()
            currentTimeOpt = timeFinishedOpt.timeIntervalSince(timeStartedOpt)
            
            if currentTimeOpt <= 0 {
                currentTimeOpt = totalTimeOpt
                timeStartedOpt = Date()
                timeFinishedOpt = timeStartedOpt.addingTimeInterval(currentTimeOpt)
                isPausedOpt = true
                isRunningOpt = false
            }

            
            
        }
    }

}

//MARK: - Unwrappers
extension TimerPlus {
    var createdAtOpt: Date {
        get { createdAt ?? Date() }
        set { createdAt = newValue }
    }
    
    var isPausedOpt: Bool {
        get { isPaused?.boolValue ?? true }
        set { isPaused = newValue as NSNumber }
    }
    
    var isRunningOpt: Bool {
        get { isRunning?.boolValue ?? true }
        set { isRunning = newValue as NSNumber }
    }
    
    var currentTimeOpt: TimeInterval {
        get { currentTime as? TimeInterval ?? 0 }
        set { currentTime = newValue as NSNumber }
    }
    
    var totalTimeOpt: TimeInterval {
        get { totalTime as? TimeInterval ?? 0 }
        set { totalTime = newValue as NSNumber }
    }
    
    var timeStartedOpt: Date {
        get { timeStarted ?? Date() }
        set { timeStarted = newValue }
    }
    
    var timeFinishedOpt: Date {
        get { timeFinished ?? Date() }
        set { timeFinished = newValue }
    }
    
    var titleOpt: String {
        get { title ?? "Found Nil" }
        set { title = newValue }
    }
    
    var soundSettingOpt: String {
        get { soundSetting ?? TimerPlus.soundSettings[0] }
        set { soundSetting = newValue }
    }
    
    var precisionSettingOpt: String {
        get { precisionSetting ?? TimerPlus.precisionSettings[0] }
        set { precisionSetting = newValue }
    }
    
    var notificationSettingOpt: String {
        get { notificationSetting ?? TimerPlus.notificationSettings[0] }
        set { notificationSetting = newValue }
    }
}


//MARK: - Converter Functions

extension String {
    
    //MARK: String to Time
    func stringToTime() -> String {
        var string = self
        
        if(string.count == 3) {
            string.insert(":", at: string.index(string.startIndex, offsetBy: 1))
        } else if (string.count == 4) {
            string.insert(":", at: string.index(string.startIndex, offsetBy: 2))
        } else if (string.count == 5) {
            string.insert(":", at: string.index(string.startIndex, offsetBy: 1))
            string.insert(":", at: string.index(string.endIndex, offsetBy: -2))
        } else if (string.count == 6) {
                string.insert(":", at: string.index(string.startIndex, offsetBy: 2))
                string.insert(":", at: string.index(string.endIndex, offsetBy: -2))
        }
        
        return string
    }
    
    
    //MARK: Calculate Time
    func calculateTime() -> TimeInterval {
        var value: TimeInterval
        
        var seconds = 0
        var minutes = 0
        var hours = 0
        
        if(self.count <= 2) {
            seconds = Int(self) ?? 0
        } else if (self.count == 3){
            seconds = Int(String(self.suffix(2))) ?? 0
            minutes = Int(String(self.prefix(1))) ?? 0
        } else if (self.count == 4) {
            seconds = Int(String(self.suffix(2))) ?? 0
            minutes = Int(String(self.prefix(2))) ?? 0
        } else if (self.count == 5) {
            seconds = Int(String(self.suffix(2))) ?? 0
            hours = Int(String(self.prefix(1))) ?? 0
            minutes = Int(String(String(self.prefix(3)).suffix(2))) ?? 0
        } else if (self.count == 6) {
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
        
        if (hours > 0) {
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
        
        
        if(precisionSetting == "Smart") {
            if (time < 60) {
                return String(format: "%0.2d.%0.2d",seconds,ms)
            } else if (time<3600) {
                return String(format: "%0.2d:%0.2d",minutes,seconds)
            } else {
                return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
            }
        } else if(precisionSetting == "On") {
            if (time < 60) {
                return String(format: "%0.2d.%0.2d",seconds,ms)
            } else if (time<3600) {
                return String(format: "%0.2d:%0.2d.%0.2d",minutes,seconds,ms)
            } else {
                return String(format: "%0.2d:%0.2d:%0.2d.%0.2d",hours,minutes,seconds,ms)
            }
        } else {
            if (time < 60) {
                return String(format: "%0.2d:%0.2d",minutes,seconds)
            } else if (time<3600) {
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
        
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
}
