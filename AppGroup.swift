//
//  AppGroup.swift
//  TimePiece
//
//  Created by Alexey Primechaev on 2/13/21.
//  Copyright © 2021 Alexey Primechaev. All rights reserved.
//

import Foundation

public enum AppGroup: String {
  case group = "group.timepiece"

  public var containerURL: URL {
    switch self {
    case .group:
      return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: self.rawValue)!
    }
  }
}
