//
//  LogItem.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 4/6/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import Foundation
import CoreData


public class LogItem: NSManagedObject, Identifiable {
    
//MARK: - Properties
    
    public var id: NSManagedObjectID {
        objectID
    }
    
    //MARK: Main Properties
    @NSManaged public var titleStored: String?
    @NSManaged public var timeStartedStored: Date?
    @NSManaged public var timeFinishedStored: Date?
    
    
    
    
    
    
    
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
    
}

//MARK: - CoreData
extension LogItem {
    static func getAllLogItems() -> NSFetchRequest<LogItem> {
        let request: NSFetchRequest<LogItem> = LogItem.fetchRequest() as! NSFetchRequest<LogItem>
        
        let sortDescriptor = NSSortDescriptor(key: "timeStartedStored", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
}
