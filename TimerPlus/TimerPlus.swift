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
    @NSManaged public var time: Date?
    @NSManaged public var timeStarted: Date?
    @NSManaged public var title: String?
    
    static let dateFormatter = RelativeDateTimeFormatter()
    
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()

}

class TimeCount {
    let currentTimePublisher = Timer.TimerPublisher(interval: 0.001, runLoop: .main, mode: .common)
    let cancellable: AnyCancellable?

    init() {
        self.cancellable = currentTimePublisher.connect() as? AnyCancellable
    }

    deinit {
        self.cancellable?.cancel()
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
