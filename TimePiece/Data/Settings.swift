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
    
    @Published var isReusableDefault: String = (defaultsStored.string(forKey: "isReusableDefault") ?? TimerPlus.reusableSettings[0]) {
        willSet {
            defaultsStored.set(newValue, forKey: "isReusableDefault")
        }
    }
    
    @Published var soundSettingDefault: String = (defaultsStored.string(forKey: "soundSettingDefault") ?? TimerPlus.soundSettings[0]) {
           willSet {
               defaultsStored.set(newValue, forKey: "soundSettingDefault")
           }
    }
    
    @Published var precisionSettingDefault: String = (defaultsStored.string(forKey: "precisionSettingDefault") ?? TimerPlus.precisionSettings[1]) {
           willSet {
               defaultsStored.set(newValue, forKey: "precisionSettingDefault")
           }
    }
    
    @Published var notificationSettingDefault: String = (defaultsStored.string(forKey: "notificationSettingDefault") ?? TimerPlus.notificationSettings[0]) {
           willSet {
               defaultsStored.set(newValue, forKey: "notificationSettingDefault")
           }
    }
    
    @Published var monthlyPrice = defaultsStored.string(forKey: "monthlyPrice") ?? "$3"
    
    @Published var yearlyPrice = defaultsStored.string(forKey: "yearlyPrice") ?? "$18"
    
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
    
    func purchaseMonthly() {
        SwiftyStoreKit.purchaseProduct("timepiecesubscription", quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                self.isSubscribed = true
                print(self.isSubscribed = true)
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
            }
        }
    }
    
    func purchaseYearly() {
        SwiftyStoreKit.purchaseProduct("timepieceyearly", quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                self.isSubscribed = true
                print(self.isSubscribed = true)
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
            }
        }
    }
    
    func restorePurchases() {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                self.isSubscribed = true
            }
            else {
                print("Nothing to Restore")
            }
        }
    }
    
    func validateSubscription() {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "b82d97a08dd74422a5116ac3779653e6")
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
                    self.isSubscribed = true
                case .expired(let expiryDate, let items):
                    print("\(productIdMonthly) is expired since \(expiryDate)\n\(items)\n")
                    self.isSubscribed = false
                case .notPurchased:
                    print("The user has never purchased \(productIdMonthly)")
                    self.isSubscribed = false
                }
                
                let productIdYearly = "timepieceyearly"
                
                let purchaseResultYearly = SwiftyStoreKit.verifySubscription(
                ofType: .autoRenewable, // or .nonRenewing (see below)
                productId: productIdYearly,
                inReceipt: receipt)
                
                switch purchaseResultYearly {
                case .purchased(let expiryDate, let items):
                    print("\(purchaseResultYearly) is valid until \(expiryDate)\n\(items)\n")
                    self.isSubscribed = true
                case .expired(let expiryDate, let items):
                    print("\(purchaseResultYearly) is expired since \(expiryDate)\n\(items)\n")
                    self.isSubscribed = false
                case .notPurchased:
                    print("The user has never purchased \(purchaseResultYearly)")
                    self.isSubscribed = false
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
                return "Rounded"
            } else if self == .serif {
                return "Serif"
            } else if self == .monospaced {
                return "Mono"
            } else {
                return "Default"
            }
        } set {
            if newValue == "Rounded" {
                self = .rounded
            } else if newValue == "Serif" {
                self = .serif
            } else if newValue == "Mono" {
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
