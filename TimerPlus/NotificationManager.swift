//
//  NotificationManager.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 2/22/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import Foundation
import UserNotifications

public let userDefaults = UserDefaults.standard

public class NotificationManager {
    
    static var badgeCount: Int {
        get { (userDefaults.value(forKey: "badgeCount") ?? 0) as! Int }
        set { if newValue < 0 {
                print("zero")
                userDefaults.set(0, forKey: "badgeCount")
            } else {
                userDefaults.set(newValue, forKey: "badgeCount")
            }
            
            
        }
    }
    
    //MARK: Request Notification Permission
    static func requestNotificationPermisson() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Approved")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    static func scheduleNotification(timer: TimerPlus) {
        print("schedule")

        requestNotificationPermisson()

        if timer.isPaused {
            
            let content = UNMutableNotificationContent()
            content.title = "\(timer.title == "" ? "Timer ⏱" : timer.title) is done"
            content.subtitle = "Tap to view"
            content.sound = UNNotificationSound.default
            badgeCount += 1
            content.badge = NSNumber(value: badgeCount)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timer.currentTime, repeats: false)
            let request = UNNotificationRequest(identifier: timer.notificationIdentifier.uuidString, content: content, trigger: trigger)
            
            
            print(content.badge)
            UNUserNotificationCenter.current().add(request)
            
            UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { request in
                print(request[0].identifier)
            })
            
        } else {
            if timer.currentTime > 0 {
                removePendingNotification(timer: timer)
            }
        }
        
    }
    
    static func removePendingNotification(timer: TimerPlus) {
        print("pending")
        print(badgeCount)
        badgeCount -= 1
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [timer.notificationIdentifier.uuidString])
    }
    
    static func removeDeliveredNotification(timer: TimerPlus) {
        print("delivered")
        print(badgeCount)
        
        badgeCount -= 1
        
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [timer.notificationIdentifier.uuidString])
        UNUserNotificationCenter.current().setBadgeCount(to: badgeCount)
    }
}
