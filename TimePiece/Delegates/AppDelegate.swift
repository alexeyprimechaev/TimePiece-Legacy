//
//  AppDelegate.swift
//  TimerPlus
//
//  Created by Alexey Primechaev on 1/5/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import UIKit
import CoreData
import SwiftyStoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var settings = Settings()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
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
        settings.getMonthlyPrice()
        settings.getYearlyPrice()
        if settings.isSubscribed {
            settings.validateSubscription()
        }
        
        
        return true
    }

    //MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    //MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
                
        let container = NSPersistentCloudKitContainer(name: "TimePiece")
        
//        guard let description = container.persistentStoreDescriptions.first else {
//            fatalError("No Descriptions found")
//        }
//
//        description.setOption(true as NSObject, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
//
//        container.viewContext.automaticallyMergesChangesFromParent = true
//        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.processUpdate), name: .NSPersistentStoreRemoteChange, object: nil)
        
        return container
    }()

    //MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
//    @objc
//    func processUpdate(notification: NSNotification) {
//        operatioQueue.addOperation {
//
//            let context = self.persistentContainer.newBackgroundContext()
//            context.performAndWait {
//                let items: [TimerItem]
//
//                do {
//                    try items = context.fetch(TimerItem.getAllTimers())
//                } catch {
//                    let nserror = error as NSError
//                    fatalError("Uh oh unexpected error\(nserror)")
//                }
//
//                if context.hasChanges {
//                    do {
//
//                    } catch {
//                        let nserror = error as NSError
//                        fatalError("Uh oh unexpected error\(nserror)")
//                    }
//                }
//
//            }
//        }
//    }
    
//    lazy var operatioQueue: OperationQueue = {
//        var queue = OperationQueue()
//        queue.maxConcurrentOperationCount = 1
//        return queue
//    }()

}

extension UNUserNotificationCenter {
    func setBadgeCount(to value: Int) {
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = value
        }
    }
}

