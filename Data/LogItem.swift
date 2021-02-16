//
//  LogItem.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 4/6/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI



public class LogItem: NSManagedObject, Identifiable {
    
    //MARK: - Properties
    
    public var id: NSManagedObjectID {
        objectID
    }
    
    //MARK: Main Properties
    @NSManaged private var titleStored: String?
    @NSManaged private var timeStartedStored: Date?
    @NSManaged private var timeFinishedStored: Date?
    @NSManaged private var isStopwatchStored: NSNumber?
    @NSManaged private var isDoneStored: NSNumber?
    
    @NSManaged public var origin: TimeItem?
    
    
    
}

//MARK: - Unwrappers
extension LogItem {
    
    var title: String {
        get { titleStored ?? "Found Nil" }
        set { titleStored = newValue }
    }
    
    var timeStarted: Date {
        get { timeStartedStored ?? Date() }
        set { timeStartedStored = newValue }
    }
    
    var timeFinished: Date {
        get { timeFinishedStored ?? Date() }
        set { timeFinishedStored = newValue }
    }
    
    var isStopwatch: Bool {
        get { isStopwatchStored?.boolValue ?? false }
        set { isStopwatchStored = NSNumber(value: newValue) }
    }
    var isDone: Bool {
        get { isDoneStored?.boolValue ?? true }
        set { isDoneStored = NSNumber(value: newValue) }
    }
    
    var time: String {
        get {
            if isStopwatch {
                return timeFinished.timeIntervalSince(timeStarted).relativeStringFromNumber()
            } else {
                return timeFinished.timeIntervalSince(timeStarted).relativeStringFromNumber()
            }
        }
    }
    
}

//MARK: - CoreData
extension LogItem {
    static func getAllLogItems() -> NSFetchRequest<LogItem> {
        let request: NSFetchRequest<LogItem> = LogItem.fetchRequest() as! NSFetchRequest<LogItem>
        
        let sortDescriptor = NSSortDescriptor(key: "timeStartedStored", ascending: false)
        
        request.sortDescriptors = [sortDescriptor]
        
        
        return request
    }
}
