//
//  TimerPlus.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/5/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import Foundation
import CoreData

public class TimerPlus: NSManagedObject, Identifiable {
    @NSManaged public var createdAt: Date?
    @NSManaged public var isPaused: NSNumber?
    @NSManaged public var time: String?
    @NSManaged public var title: String?
    
}

extension TimerPlus {
    static func getAllTimers() -> NSFetchRequest<TimerPlus> {
        let request: NSFetchRequest<TimerPlus> = TimerPlus.fetchRequest() as! NSFetchRequest<TimerPlus>
        
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
}
