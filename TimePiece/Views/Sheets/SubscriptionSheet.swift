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
            
            HeaderBar(leadingAction: { self.discard() }, leadingTitle: dismissString, leadingIcon: "xmark", trailingAction: {
                print(self.settings.isSubscribed)
                self.restorePurchases()
                print(self.settings.isSubscribed)
            }, trailingTitle: restoreString, trailingIcon: "arrow.clockwise")
                
                .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertText1), message: Text(alertText2), dismissButton: .default(Text("Okay")))
            }
            
            VStack(alignment: .leading, spacing: 0) {
                
                HStack(alignment: .bottom, spacing: 4) {
                    Text(timePieceString)
                        .title()
                        
                    Image("PlusIcon")
                        .padding(.bottom, 9)
                }.padding(7)
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 14) {
                        SubscriptionBadge(icon: "arrow.clockwise.circle.fill", title: sellingPoint1String, subtitle: sellingPoint1SecondString)
                        SubscriptionBadge(icon: "bell.circle.fill", title: sellingPoint2String, subtitle: sellingPoint2SecondString)
                        SubscriptionBadge(icon: "book.circle.fill", title: sellingPoint3String, subtitle: sellingPoint3SecondString)
                        SubscriptionBadge(icon: "star.circle.fill", title: sellingPoint4String, subtitle: sellingPoint4SecondString)
                        SubscriptionBadge(icon: "ellipsis.circle.fill", title: sellingPoint5String, subtitle: sellingPoint5SecondString)
                        SubscriptionBadge(icon: "heart.circle.fill", title: sellingPoint6String, subtitle: sellingPoint6SecondString)
                        
 
                    }.padding(.top, 14).frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                    
                }
                Spacer()
                VStack(spacing: 14) {
                    SubscriptionButton(title: subscription1String, promo: subscription1SecondString, price: "\(settings.monthlyPrice)", duration: subscription1PeriodString, isAccent: true, action: {
                            self.purchaseMonthly()
                        })
                        SubscriptionButton(title: subscription2String, promo: subscription2SecondString, price: "\(settings.yearlyPrice)", duration: subscription2PeriodString, isAccent: false, action: {
                            self.purchaseYearly()
                        })
                }.padding(.trailing, 28)
                    
                Text(subscriptionDetailsString).secondaryText().padding(14).padding(.trailing, 14)
                HStack(spacing: 0) {
                    Spacer()
                        Button(action: {
                            UIApplication.shared.open(URL(string: "https://number16.github.io/timepiece-terms.html")!)
                        }) {
                         Text(termsDetailsString)
                            .smallTitle()
                            .foregroundColor(Color.primary)
                            .padding(7)
                        }
                        
                    Spacer()
                    Spacer().frame(width: 21)
                }
                Spacer().frame(height: 14)
            }.padding(.leading, 21)
        }
        
    }
    
    func restorePurchases() {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "b82d97a08dd74422a5116ac3779653e6")
        
        var monthly = false
        var yearly = true
        
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
                        monthly = true
                        if monthly || yearly {
                            self.settings.isSubscribed = true
                        } else {
                            self.settings.isSubscribed = false
                        }
                        
                    case .expired(let expiryDate, let items):
                        //print("\(productIdMonthly) is expired since \(expiryDate)\n\(items)\n")
                        monthly = false
                        if monthly || yearly {
                            self.settings.isSubscribed = true
                        } else {
                            self.settings.isSubscribed = false
                        }
                        self.alertText1 = "Failed"
                        self.alertText2 = "Subscription has expired on \(TimerItem.createdAtFormatter.string(from: expiryDate))"
                        self.showingAlert = true
                    case .notPurchased:
                        //print("The user has never purchased \(productIdMonthly)")
                        monthly = false
                        if monthly || yearly {
                            self.settings.isSubscribed = true
                        } else {
                            self.settings.isSubscribed = false
                        }
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
                        yearly = true
                        if monthly || yearly {
                            self.settings.isSubscribed = true
                        } else {
                            self.settings.isSubscribed = false
                        }
                    case .expired(let expiryDate, let items):
                        //print("\(purchaseResultYearly) is expired since \(expiryDate)\n\(items)\n")
                        yearly = false
                        if monthly || yearly {
                            self.settings.isSubscribed = true
                        } else {
                            self.settings.isSubscribed = false
                        }
                        self.alertText1 = "Failed"
                        self.alertText2 = "Subscription has expired on \(TimerItem.createdAtFormatter.string(from: expiryDate))"
                        self.showingAlert = true
                    case .notPurchased:
                        yearly = false
                        if monthly || yearly {
                            self.settings.isSubscribed = true
                        } else {
                            self.settings.isSubscribed = false
                        }
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
