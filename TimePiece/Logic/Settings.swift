//
//  Settings.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 2/28/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftyStoreKit

public let defaultsStored = UserDefaults.standard

public class Settings: ObservableObject {
    
    @Published var showingSubscription: Bool = false
    
    @Published var nextNotificationDate: Date = ((defaultsStored.value(forKey: "nextNotificationDate") ?? Date().addingTimeInterval(36000)) as! Date) {
        willSet {
            defaultsStored.set(newValue, forKey: "nextNotificationDate")
        }
    }
    
    @Published var hasSeenTrends: Bool = ((defaultsStored.value(forKey: "hasSeenTrends") ?? true) as! Bool) {
        willSet {
            defaultsStored.set(newValue, forKey: "hasSeenTrends")
        }
    }
    
    @Published var isSubscribed: Bool = ((defaultsStored.value(forKey: "isSubscribed") ?? false) as! Bool) {
        willSet {
            defaultsStored.set(newValue, forKey: "isSubscribed")
        }
    }
    
    @Published var fontDesign: Font.Design = ((defaultsStored.value(forKey: "fontDesign") ?? "Default") as! String).fontDesignValue {
        willSet {
            defaultsStored.set(newValue.string, forKey: "fontDesign")
        }
    }
    
    @Published var isMonochrome: Bool = ((defaultsStored.value(forKey: "isMonochrome") ?? false) as! Bool) {
        willSet {
            defaultsStored.set(newValue, forKey: "isMonochrome")
        }
    }
    
    @Published var showingDividers: Bool = ((defaultsStored.value(forKey: "showingDividers") ?? true) as! Bool) {
        willSet {
            defaultsStored.set(newValue, forKey: "showingDividers")
        }
    }
    
    @Published var showInLogDefault: Bool = ((defaultsStored.value(forKey: "showInLogDefault") ?? true) as! Bool) {
        willSet {
            defaultsStored.set(newValue, forKey: "showInLogDefault")
        }
    }
    
    @Published var isReusableDefault: String = (defaultsStored.string(forKey: "isReusableDefault") ?? TimerItem.reusableSettings[1]) {
        willSet {
            defaultsStored.set(newValue, forKey: "isReusableDefault")
        }
    }
    
    @Published var soundSettingDefault: String = (defaultsStored.string(forKey: "soundSettingDefault") ?? TimerItem.soundSettings[0]) {
           willSet {
               defaultsStored.set(newValue, forKey: "soundSettingDefault")
           }
    }
    
    @Published var precisionSettingDefault: String = (defaultsStored.string(forKey: "precisionSettingDefault") ?? TimerItem.precisionSettings[1]) {
           willSet {
               defaultsStored.set(newValue, forKey: "precisionSettingDefault")
           }
    }
    
    @Published var notificationSettingDefault: String = (defaultsStored.string(forKey: "notificationSettingDefault") ?? TimerItem.notificationSettings[0]) {
           willSet {
               defaultsStored.set(newValue, forKey: "notificationSettingDefault")
           }
    }
    
    @Published var monthlyPrice = defaultsStored.string(forKey: "monthlyPrice") ?? "$3" {
        willSet {
            defaultsStored.set(newValue, forKey: "monthlyPrice")
        }
    }
    
    @Published var yearlyPrice = defaultsStored.string(forKey: "yearlyPrice") ?? "$18" {
        willSet {
            defaultsStored.set(newValue, forKey: "yearlyPrice")
        }
    }

    func getMonthlyPrice() {
        SwiftyStoreKit.retrieveProductsInfo(["timepiecesubscription"]) { result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
                self.monthlyPrice = priceString
                print(self.monthlyPrice)
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
                self.monthlyPrice = "$3"
            }
            else {
                print("Error: \(result.error)")
                self.monthlyPrice = "$3"
            }
        }
    }
    
    func getYearlyPrice() {
        SwiftyStoreKit.retrieveProductsInfo(["timepieceyearly"]) { result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
                self.yearlyPrice = priceString
                print(self.monthlyPrice)
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
                self.yearlyPrice = "$18"
            }
            else {
                print("Error: \(result.error)")
                self.yearlyPrice = "$18"
            }
        }
    }
    
    
    func validateSubscription() {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "b82d97a08dd74422a5116ac3779653e6")
        
        var monthly = false
        var yearly = false
        
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let productIdMonthly = "timepiecesubscription"
                // Verify the purchase of a Subscription
                let purchaseResultMonthly = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable, // or .nonRenewing (see below)
                    productId: productIdMonthly,
                    inReceipt: receipt)
                    
                switch purchaseResultMonthly {
                case .purchased(let expiryDate, let items):
                    print("\(productIdMonthly) is valid until \(expiryDate)\n\(items)\n")
                    monthly = true
                    if monthly || yearly {
                        self.isSubscribed = true
                    } else {
                        self.isSubscribed = false
                    }
                case .expired(let expiryDate, let items):
                    print("\(productIdMonthly) is expired since \(expiryDate)\n\(items)\n")
                    monthly = false
                    if monthly || yearly {
                        self.isSubscribed = true
                    } else {
                        self.isSubscribed = false
                    }
                case .notPurchased:
                    print("The user has never purchased \(productIdMonthly)")
                    monthly = false
                    if monthly || yearly {
                        self.isSubscribed = true
                    } else {
                        self.isSubscribed = false
                    }
                }
                
                let productIdYearly = "timepieceyearly"
                
                let purchaseResultYearly = SwiftyStoreKit.verifySubscription(
                ofType: .autoRenewable, // or .nonRenewing (see below)
                productId: productIdYearly,
                inReceipt: receipt)
                
                switch purchaseResultYearly {
                case .purchased(let expiryDate, let items):
                    print("\(purchaseResultYearly) is valid until \(expiryDate)\n\(items)\n")
                    yearly = true
                    if monthly || yearly {
                        self.isSubscribed = true
                    } else {
                        self.isSubscribed = false
                    }
                case .expired(let expiryDate, let items):
                    print("\(purchaseResultYearly) is expired since \(expiryDate)\n\(items)\n")
                    yearly = false
                    if monthly || yearly {
                        self.isSubscribed = true
                    } else {
                        self.isSubscribed = false
                    }
                case .notPurchased:
                    print("The user has never purchased \(purchaseResultYearly)")
                    yearly = false
                    if monthly || yearly {
                        self.isSubscribed = true
                    } else {
                        self.isSubscribed = false
                    }
                }

            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }

    }

    
    
}

extension Font.Design {
    var string: String {
        get {
            if self == .rounded {
                return "rounded"
            } else if self == .serif {
                return "serif"
            } else if self == .monospaced {
                return "mono"
            } else {
                return "default"
            }
        } set {
            if newValue == "rounded" {
                self = .rounded
            } else if newValue == "serif" {
                self = .serif
            } else if newValue == "mono" {
                self = .monospaced
            } else {
                self = .default
            }
        }
    }
}

extension String {
    var fontDesignValue: Font.Design {
        get {
            if self == "Rounded" {
                return .rounded
            } else if self == "Serif" {
                return .serif
            } else if self == "Mono" {
                return .monospaced
            } else {
                return .default
            }
        } set {
            if newValue == .rounded {
                self = "Rounded"
            } else if newValue == .serif {
                self = "Serif"
            } else if newValue == .monospaced {
                self = "Mono"
            } else {
                self = "Default"
            }
        }
    }
}
