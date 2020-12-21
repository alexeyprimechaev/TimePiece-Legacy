//
//  TimePieceApp.swift
//  Shared
//
//  Created by Alexey Primechaev on 8/25/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI
import SwiftyStoreKit

@main
struct TimePieceApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @Environment(\.scenePhase) var scenePhase
    let persistenceController = PersistenceController.shared
    var settings = Settings()
    var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(settings)
                .environmentObject(appState)
                .onChange(of: scenePhase) { phase in
                    if phase == .active {
                        print("start")
                        let calendar = Calendar(identifier: .gregorian)

                        // Weekday units are the numbers 1 through n, where n is the number of days in the week.
                        // For example, in the Gregorian calendar, n is 7 and Sunday is represented by 1.
                       var date = DateComponents()
                        
                            date.hour = 10
                            date.minute = 00
                            date.weekday = 7
                            date.calendar = calendar
                        
                        
                        let nextSunday = calendar.nextDate(after: Date(), matching: date, matchingPolicy: .nextTimePreservingSmallerComponents) // "Jan 14, 2018 at 12:00 AM"
                        
                        settings.nextNotificationDate = nextSunday ?? Date().addingTimeInterval(3600)
                        
                        if Date() > settings.nextNotificationDate {
                            settings.hasSeenTrends = false
                        }
                        
                        settings.getMonthlyPrice()
                        settings.getYearlyPrice()
                        
                        //MARK: Удолить на релизе
                        settings.isSubscribed = true
//                        if settings.isSubscribed {
//                            settings.validateSubscription()
//                        }
                        
                        
                        
                    }
                    if phase == .background {
                        persistenceController.saveContext()
                    }
                }
        }
    }
    
    
    //MARK: Legacy
    class AppDelegate: NSObject, UIApplicationDelegate {
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            
            print("appdelegate")
            
            NotificationManager.badgeCount = 0
            UIApplication.shared.applicationIconBadgeNumber = 0
            print(NotificationManager.badgeCount)
            
            
            
            SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
                for purchase in purchases {
                    switch purchase.transaction.transactionState {
                    case .purchased, .restored:
                        if purchase.needsFinishTransaction {
                            // Deliver content from server, then:
                            SwiftyStoreKit.finishTransaction(purchase.transaction)
                        }
                        // Unlock content
                    case .failed, .purchasing, .deferred:
                        break // do nothing
                        
                    }
                }
            }
            
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["openApp"])
            NotificationManager.createRepeatingNotification()
            
            
            return true
        }
    }

}
