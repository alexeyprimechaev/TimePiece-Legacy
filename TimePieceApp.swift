//
//  TimePieceApp.swift
//  Shared
//
//  Created by Alexey Primechaev on 8/25/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI
import SwiftyStoreKit
import WidgetKit


@main
struct TimePieceApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @Environment(\.scenePhase) var scenePhase
    let persistenceController = PersistenceController.shared
    @FetchRequest(fetchRequest: TimeItem.getAllTimeItems()) var timeItems: FetchedResults<TimeItem>
    @ObservedObject var settings = Settings()
    @ObservedObject var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if settings.selectedView == .classic {
                    ContentView()
                } else {
                    HomeView()
                }
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environmentObject(settings)
            .environmentObject(appState)
            .navigationBarTitle("TimePiece")
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
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
            .onOpenURL { url in
                if url.absoluteString == "timepiece://newtimeitem" {
                    appState.newTimeItem = TimeItem.newTimeItem(totalTime: 0, title: "", context: persistenceController.container.viewContext, reusableSetting: settings.isReusableDefault, soundSetting: settings.soundSettingDefault, precisionSetting: settings.precisionSettingDefault, notificationSetting: settings.notificationSettingDefault, showInLog: settings.showInLogDefault, isStopwatch: false, order: timeItems.count)
                    appState.activeSheet = 1
                    appState.showingSheet = true
                } else {
                    if let objectID = url.absoluteString.replacingOccurrences(of: "timepiece://", with: "") as String? {
                        
                        let context = persistenceController.container.viewContext
                        let request = TimeItem.getAllTimeItems()
                        
                        var results = [TimeItem]()
                        
                        do { results = try context.fetch(request) }
                        catch let error as NSError {print("error")}
                        
                        if let timeItem = results.first(where: { item in
                            item.objectID.uriRepresentation().absoluteString == objectID
                            
                        })  {
                            appState.selectedTimeItem = timeItem
                            appState.activeSheet = 0
                            appState.showingSheet = true
                        } else {
                            
                        }
                        
                    }
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
