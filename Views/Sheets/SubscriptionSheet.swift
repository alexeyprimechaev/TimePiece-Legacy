//
//  SubscriptionSheet.swift
//  TimePiece (iOS)
//
//  Created by Alexey Primechaev on 2/22/21.
//  Copyright © 2021 Alexey Primechaev. All rights reserved.
//

import SwiftUI
import SwiftyStoreKit

struct SubscriptionSheet_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionSheet(discard: {}).environmentObject(Settings()).environmentObject(AppState())
    }
}

struct SubscriptionSheet: View {
    
    @EnvironmentObject var settings: Settings
    
    var discard: () -> Void
    
    @State var showingAlert = false
    @State var alertText1 = "Failed"
    @State var alertText2 = "Some error occured..."
    
    @State var hasFinishedRestoring = true
    @State var hasFinishedMonthly = true
    @State var hasFinishedYearly = true
    
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderBar(showingMenu: false) {
                RegularButton(title: Strings.dismiss, icon: "chevron.down") {
                    discard()
                }
            } trailingItems: {
                LoadingRegularButton(title: Strings.restore, icon: "arrow.clockwise", hasFinishedLoading: $hasFinishedRestoring) {
                    restorePurchases()
                }
            }
//            HeaderBar(leadingAction: discard,
//                      leadingTitle: Strings.dismiss,
//                      leadingIcon: "chevron.down",
//                      trailingAction: {self.restorePurchases()},
//                      trailingTitle: Strings.restore,
//                      trailingIcon: "arrow.clockwise",
//                      trailingIsHidden: true)
            GeometryReader { geometry in
                TitledScrollView {
                    let baseWidth = geometry.size.width-28-56
                    
                    VStack(spacing: 14) {
                        HStack(spacing: 14) {
                            SubscriptionPointView(color: .primary, image: "textformat", text: "Customize Appearance").frame(width: baseWidth * 1/3, height: 112)
                            SubscriptionPointView(style: .medium,
                                                  text: "Analyze how you've spent\nyour time",
                                                  images: ["clock.fill","heart.circle.fill","arrow.right.circle.fill","number.circle.fill"],
                                                  colors: [Color(.systemTeal), .pink, .purple, .orange])
                                .frame(width: baseWidth * 2/3 + 14, height: 112)
                        }
                        HStack(spacing: 14) {
                            SubscriptionPointView(style: .large, isSFSymbol: true, text: "Reuse timers for your favorite activities", images: ["🍳","🥓","🍵","🥩","🍲","🫖","📚", "📱","💻","🏢", "⏲","🍅","⏱", "✈️","🚙","🪥","🧺","🧹","🪣","🚿","🛁","🏃🏼‍♀️","🏋🏿","💪","⚽️","🧘🏿","🏈"]).frame(width: baseWidth * 2/3 + 14, height: 238)
                            VStack(spacing: 14) {
                                SubscriptionPointView(color: Color(.systemIndigo), image: "ellipsis.circle.fill", text: "Show Milliseconds").frame(width: baseWidth * 1/3, height: 112)
                                SubscriptionPointView(color: .green, image: "speaker.wave.2.fill", text: "Pick sounds for each timer").frame(width: baseWidth * 1/3, height: 112)
                                
                            }
                        }
                        HStack(spacing: 14) {
                            SubscriptionPointView(color: .blue, image: "paperplane.fill", text: "Help develop new features").frame(width: baseWidth * 1/3, height: 112)
                            SubscriptionPointView(style: .medium,
                                                  isSFSymbol: false, text: "Support the creators", images: ["lex", "kex"]).frame(width: baseWidth * 2/3 + 14, height: 112)
                        }
                        
                        
                        
                    }.padding(.top, 21).padding(.horizontal, 7)
                    Divider().padding(14).padding(.horizontal, 14)
                    VStack(alignment: .leading, spacing: 14) {
                        SubscriptionButton(title: "🆕 Get For Free 🆓", promo: "Provide feedback and get the app for free", price: "", duration: "", isAccent: true, isFree: true, hasFinishedLoading: Binding.constant(true), action: openGoogleForm)
                        SubscriptionButton(title: Strings.subscription1, promo: Strings.subscription1Second, price: "\(settings.monthlyPrice)", duration: Strings.subscription1Period, isAccent: false, hasFinishedLoading: $hasFinishedMonthly, action: purchaseMonthly)
                        SubscriptionButton(title: Strings.subscription2, promo: Strings.subscription2Second, price: "\(settings.yearlyPrice)", duration: Strings.subscription2Period, isAccent: false, hasFinishedLoading: $hasFinishedYearly, action: purchaseYearly)
                        
                        Text(Strings.subscriptionDetails).fontSize(.secondaryText).multilineTextAlignment(.center)
                        HStack(spacing: 0) {
                            Spacer()
                            Button {
                                UIApplication.shared.open(URL(string: "https://number16.github.io/timepiece-terms.html")!)
                            } label: {
                                Text(Strings.termsDetails)
                                    .fontSize(.smallTitle)
                                    .padding(7)
                            }
                            
                            Spacer()
                        }
                    }.padding(.horizontal, 7)
                    
                    
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertText1), message: Text(alertText2), dismissButton: .default(Text("Okay")))
            }
            
            
            
            
            
            
            
            
        }.background(Color("secondaryBackground").ignoresSafeArea(.all))
        
    }
    
    func openGoogleForm() {
        if let url = URL(string: "https://forms.gle/RhowbkEMV99KG8nj8"){
            UIApplication.shared.open(url)
        }
    }
    
    func restorePurchases() {
        self.hasFinishedRestoring = false
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
                    //print("\(productIdMonthly) is valid until \(expiryDate)\n\(items)\n")
                    monthly = true
                    if monthly || yearly {
                        self.settings.isSubscribed = true
                    } else {
                        self.settings.isSubscribed = false
                    }
                    print("monthly purchased")
                    self.alertText1 = "Success"
                    self.alertText2 = "Subscription valid until \(expiryDate)"
                    self.showingAlert = true
                    self.discard()
                    
                case .expired(let expiryDate, let items):
                    //print("\(productIdMonthly) is expired since \(expiryDate)\n\(items)\n")
                    monthly = false
                    if monthly || yearly {
                        self.settings.isSubscribed = true
                    } else {
                        self.settings.isSubscribed = false
                    }
                    print("monthly expired")
                    self.alertText1 = "Failed"
                    self.alertText2 = "Subscription has expired on \(TimeItem.createdAtFormatter.string(from: expiryDate))"
                    self.showingAlert = true
                case .notPurchased:
                    //print("The user has never purchased \(productIdMonthly)")
                    monthly = false
                    if monthly || yearly {
                        self.settings.isSubscribed = true
                    } else {
                        self.settings.isSubscribed = false
                    }
                    print("monthly not purchased")
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
                    print("yearly purchased")
                    self.alertText1 = "Success"
                    self.alertText2 = "Subscription valid until \(expiryDate)"
                    self.showingAlert = true
                    self.discard()
                    
                case .expired(let expiryDate, let items):
                    //print("\(purchaseResultYearly) is expired since \(expiryDate)\n\(items)\n")
                    yearly = false
                    if monthly || yearly {
                        self.settings.isSubscribed = true
                    } else {
                        self.settings.isSubscribed = false
                    }
                    print("yearly expired")
                    self.alertText1 = "Failed"
                    self.alertText2 = "Subscription has expired on \(TimeItem.createdAtFormatter.string(from: expiryDate))"
                    self.showingAlert = true
                case .notPurchased:
                    yearly = false
                    if monthly || yearly {
                        self.settings.isSubscribed = true
                    } else {
                        self.settings.isSubscribed = false
                    }
                    print("yearly not purchased")
                    self.alertText1 = "Failed"
                    self.alertText2 = "You have never purchased \(purchaseResultYearly)"
                    self.showingAlert = true
                    
                }
                self.hasFinishedRestoring = true
                
            case .error(let error):
                print("Receipt verification failed: \(error)")
                self.hasFinishedRestoring = true
            }
            self.showingAlert = true
            print("mdems")
        }
    }
    
    func purchaseMonthly() {
        self.hasFinishedMonthly = false
        SwiftyStoreKit.purchaseProduct("timepiecesubscription", quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                self.settings.isSubscribed = true
                self.discard()
                self.hasFinishedMonthly = true
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
                self.hasFinishedMonthly = true
            }
        }
    }
    
    func purchaseYearly() {
        self.hasFinishedYearly = false
        SwiftyStoreKit.purchaseProduct("timepieceyearly", quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                self.hasFinishedYearly = true
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
                self.hasFinishedYearly = true
            }
        }
    }
}
