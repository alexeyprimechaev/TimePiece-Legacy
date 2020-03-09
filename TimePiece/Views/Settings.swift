//
//  Settings.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 2/28/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import Foundation
import SwiftUI

public let defaultsStored = UserDefaults.standard

public class Settings: ObservableObject {
    
    @Published var showingSubscription: Bool = false
    
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
    
    @Published var precisionSettingDefault: String = (defaultsStored.string(forKey: "precisionSettingDefault") ?? TimerPlus.precisionSettings[0]) {
           willSet {
               defaultsStored.set(newValue, forKey: "precisionSettingDefault")
           }
    }
    
    @Published var notificationSettingDefault: String = (defaultsStored.string(forKey: "notificationSettingDefault") ?? TimerPlus.notificationSettings[0]) {
           willSet {
               defaultsStored.set(newValue, forKey: "notificationSettingDefault")
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
