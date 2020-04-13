//
//  SubscriptionSheet.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 3/9/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import SwiftUI
import SwiftyStoreKit

struct SubscriptionSheet: View {
    
    @EnvironmentObject var settings: Settings
    
    var discard: () -> ()
    
    @State var showingAlert = false
    @State var alertText1 = "Failed"
    @State var alertText2 = "Some error occured..."
        
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            HeaderBar(leadingAction: { self.discard() }, leadingTitle: "Dismiss", leadingIcon: "xmark", trailingAction: {
                print(self.settings.isSubscribed)
                self.restorePurchases()
                print(self.settings.isSubscribed)
            }, trailingTitle: "Restore", trailingIcon: "arrow.clockwise")
                
                .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertText1), message: Text(alertText2), dismissButton: .default(Text("Okay")))
            }
            
            VStack(alignment: .leading, spacing: 0) {
                
                HStack(alignment: .bottom, spacing: 4) {
                    Text("TimePiece")
                        .title()
                        
                    Image("PlusIcon")
                        .padding(.bottom, 9)
                }.padding(7)
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 21) {
                        SubscriptionBadge(icon: "arrow.clockwise.circle.fill", title: "Reusable Timers. Unlimited.", subtitle: "Create Timers that don't expire")
                        SubscriptionBadge(icon: "ellipsis.circle.fill", title: "Higher Precision", subtitle: "Millisecond accuracy")
                        SubscriptionBadge(icon: "bell.circle.fill", title: "Control notifications & sounds", subtitle: "For each timer separately")
                        SubscriptionBadge(icon: "star.circle.fill", title: "Customize appearance", subtitle: "Choose colors and fonts")
                        SubscriptionBadge(icon: "heart.circle.fill", title: "Support the creators", subtitle: "And invest in future features")
                        
 
                    }.padding(.top, 14).frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                    
                }
                Spacer()
                HStack(alignment: .top, spacing: 0) {
                    Spacer().frame(width:7)
                    VStack() {
                        MainButton(icon: "creditcard.fill", title: "Free Trial", highPriority: true, action: {
                            self.purchaseMonthly()
                        })
                        Text("7 days free,").smallTitle()
                        Spacer().frame(height:4)
                        Text("\(settings.monthlyPrice)/Month").secondaryText()
                    }
                    Spacer().frame(width:28)
                    VStack() {
                        MainButton(icon: "creditcard.fill", title: "Yearly", action: {
                            self.purchaseYearly()
                        })
                        Text("50% Off").smallTitle()
                        Spacer().frame(height:4)
                        Text("\(settings.yearlyPrice)/Year").secondaryText()
                    }
                    Spacer().frame(width:28)
                }.padding(.bottom, 21)
                Text("Payment will be charged to iTunes Account at confirmation of purchase. Subscription automatically renews unless auto-renew is turned off at least 24 hours before the end of the current period.").secondaryText().padding(7).padding(.bottom, 14).padding(.trailing, 21)
                HStack(spacing: 14) {
                    HStack() {
                        Image(systemName: "doc")
                        Text("Privacy Policy")
                    }.smallTitle()
                    HStack() {
                        Image(systemName: "doc")
                        Text("Terms of Service")
                    }.smallTitle()
                }.padding(7)
                Spacer().frame(height: 14)
            }.padding(.leading, 21)
        }
        
    }
    
    func restorePurchases() {
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
                        //print("\(productIdMonthly) is valid until \(expiryDate)\n\(items)\n")
                        self.settings.isSubscribed = true
                    case .expired(let expiryDate, let items):
                        //print("\(productIdMonthly) is expired since \(expiryDate)\n\(items)\n")
                        self.settings.isSubscribed = false
                        self.alertText1 = "Failed"
                        self.alertText2 = "Subscription has expired on \(TimerItem.createdAtFormatter.string(from: expiryDate))"
                        self.showingAlert = true
                    case .notPurchased:
                        //print("The user has never purchased \(productIdMonthly)")
                        self.settings.isSubscribed = false
                        self.alertText1 = "Failed"
                        self.alertText2 = "You have never purchased \(productIdMonthly)"
                        self.showingAlert = true
                    }
                
                let productIdYearly = "timepieceyearly"
                
                let purchaseResultYearly = SwiftyStoreKit.verifySubscription(
                ofType: .autoRenewable, // or .nonRenewing (see below)
                productId: productIdYearly,
                inReceipt: receipt)
                
                switch purchaseResultYearly {
                    
                    case .purchased(let expiryDate, let items):
                        //print("\(purchaseResultYearly) is valid until \(expiryDate)\n\(items)\n")
                        self.settings.isSubscribed = true
                    case .expired(let expiryDate, let items):
                        //print("\(purchaseResultYearly) is expired since \(expiryDate)\n\(items)\n")
                        self.settings.isSubscribed = false
                        self.alertText1 = "Failed"
                        self.alertText2 = "Subscription has expired on \(TimerItem.createdAtFormatter.string(from: expiryDate))"
                        self.showingAlert = true
                    case .notPurchased:
                        //print("The user has never purchased \(purchaseResultYearly)")
                        self.settings.isSubscribed = false
                        self.alertText1 = "Failed"
                        self.alertText2 = "You have never purchased \(purchaseResultYearly)"
                        self.showingAlert = true
                    
                }

            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
    }
    
    func purchaseMonthly() {
        SwiftyStoreKit.purchaseProduct("timepiecesubscription", quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                self.settings.isSubscribed = true
                self.discard()
            case .error(let error):
                switch error.code {
                case .unknown:
                    print("Unknown error. Please contact support")
                    self.showingAlert = true
                case .clientInvalid:
                    print("Not allowed to make the payment")
                    self.showingAlert = true
                case .paymentCancelled: break
                case .paymentInvalid:
                    print("The purchase identifier was invalid")
                    self.showingAlert = true
                case .paymentNotAllowed:
                    print("The device is not allowed to make the payment")
                    self.showingAlert = true
                case .storeProductNotAvailable:
                    print("The product is not available in the current storefront")
                    self.showingAlert = true
                case .cloudServicePermissionDenied:
                    print("Access to cloud service information is not allowed")
                    self.showingAlert = true
                case .cloudServiceNetworkConnectionFailed:
                    print("Could not connect to the network")
                    self.showingAlert = true
                case .cloudServiceRevoked:
                    print("User has revoked permission to use this cloud service")
                    self.showingAlert = true
                default:
                    print((error as NSError).localizedDescription)
                    self.showingAlert = true
                }
            }
        }
    }
    
    func purchaseYearly() {
        SwiftyStoreKit.purchaseProduct("timepieceyearly", quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                self.settings.isSubscribed = true
                self.discard()
            case .error(let error):
            switch error.code {
            case .unknown:
                print("Unknown error. Please contact support")
                self.showingAlert = true
            case .clientInvalid:
                print("Not allowed to make the payment")
                self.showingAlert = true
            case .paymentCancelled: break
            case .paymentInvalid:
                print("The purchase identifier was invalid")
                self.showingAlert = true
            case .paymentNotAllowed:
                print("The device is not allowed to make the payment")
                self.showingAlert = true
            case .storeProductNotAvailable:
                print("The product is not available in the current storefront")
                self.showingAlert = true
            case .cloudServicePermissionDenied:
                print("Access to cloud service information is not allowed")
                self.showingAlert = true
            case .cloudServiceNetworkConnectionFailed:
                print("Could not connect to the network")
                self.showingAlert = true
            case .cloudServiceRevoked:
                print("User has revoked permission to use this cloud service")
                self.showingAlert = true
            default:
                print((error as NSError).localizedDescription)
                self.showingAlert = true
            }
            }
        }
    }

    
}
