//
//  Haptics.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 4/3/20.
//  Copyright © 2020 Alexey Primechaev. All rights reserved.
//

import Foundation
import UIKit

public func regularHaptic() {
    let generator = UIImpactFeedbackGenerator(style: .rigid)
    generator.impactOccurred()
}

public func mediumHaptic() {
    let generator = UIImpactFeedbackGenerator(style: .medium)
    generator.impactOccurred()
}

public func lightHaptic() {
    let generator = UIImpactFeedbackGenerator(style: .light)
    generator.impactOccurred()
}

