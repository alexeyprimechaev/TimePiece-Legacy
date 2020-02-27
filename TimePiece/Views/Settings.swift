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
    
    @Published var fontDesign: Font.Design = (defaultsStored.value(forKey: "fontDesign") as! String).fontDesignValue {
        willSet {
            defaultsStored.set(newValue.string, forKey: "fontDesign")
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
