//
//  NotificationManager.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 2/22/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import Foundation
import UserNotifications

public class NotificationManager {
    
    static var badgeCount: Int {
        
        get { (defaultsStored.value(forKey: "badgeCount") ?? 0) as! Int }
        set { if newValue < 0 {
                print("zero")
                defaultsStored.set(0, forKey: "badgeCount")
            } else {
                defaultsStored.set(newValue, forKey: "badgeCount")
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
    
    static func scheduleNotification(timer: TimerItem) {
        print("schedule")

        requestNotificationPermisson()

        if timer.isPaused {
            
            let content = UNMutableNotificationContent()
            content.title = "\(timer.title == "" ? NSLocalizedString("timer", comment: "Timer") : timer.title) is done"
            content.subtitle = "Tap to view"
            content.sound = UNNotificationSound.default
            badgeCount += 1
            content.badge = NSNumber(value: badgeCount)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timer.remainingTime, repeats: false)
            let request = UNNotificationRequest(identifier: timer.notificationIdentifier.uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
 
            
        } else {
            if timer.remainingTime > 0 {
                removePendingNotification(timer: timer)
            }
        }
        
    }
    
    static func scheduleRepeatingNotification() {
        
        requestNotificationPermisson()
        
        let content = UNMutableNotificationContent()
        
        content.title = "View how you've spent your time this week in the Log"
        
        content.sound = UNNotificationSound.default
        badgeCount += 1
        content.badge = NSNumber(value: badgeCount)
        
    }
    
    static func removePendingNotification(timer: TimerItem) {
        print("pending")
        print(badgeCount)
        badgeCount -= 1
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [timer.notificationIdentifier.uuidString])
    }
    
    static func removeDeliveredNotification(timer: TimerItem) {
        print("delivered")
        print(badgeCount)
        
        badgeCount -= 1
        
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [timer.notificationIdentifier.uuidString])
        //UNUserNotificationCenter.current().setBadgeCount(to: badgeCount)
    }
    
    static func createRepeatingNotification() {
            var date = DateComponents()
        
            date.hour = 10
            date.minute = 00
            date.weekday = 7
        
            print("fuck")
        
            let content = UNMutableNotificationContent()
            content.title = "Check how you've been spending your time this week"
//            content.body = "Don't forget to log your mood"
            content.sound = UNNotificationSound.default
            badgeCount += 1
            content.badge = NSNumber(value: badgeCount)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
            let request = UNNotificationRequest(identifier: "openApp", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
          
        })
    }
}
