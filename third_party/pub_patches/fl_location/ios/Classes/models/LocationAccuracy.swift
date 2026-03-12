//
//  LocationAccuracy.swift
//  fl_location
//
//  Created by WOO JIN HWANG on 2021/07/28.
//

import CoreLocation
import Foundation

enum LocationAccuracy: Int {
  case POWER_SAVE = 0
  case LOW = 1
  case BALANCED = 2
  case HIGH = 3
  case BEST = 4
  case NAVIGATION = 5
  
  static func fromIndex(index: Int) -> LocationAccuracy {
    switch index {
      case 1:
        return .LOW
      case 2:
        return .BALANCED
      case 3:
        return .HIGH
      case 4:
        return .BEST
      case 5:
        return .NAVIGATION
      default:
        return .POWER_SAVE
    }
  }
  
  func toCLLocationAccuracy() -> CLLocationAccuracy {
    switch self {
      case .POWER_SAVE:
        return kCLLocationAccuracyThreeKilometers
      case .LOW:
        return kCLLocationAccuracyKilometer
      case .BALANCED:
        return kCLLocationAccuracyHundredMeters
      case .HIGH:
        return kCLLocationAccuracyNearestTenMeters
      case .BEST:
        return kCLLocationAccuracyBest
      case .NAVIGATION:
        return kCLLocationAccuracyBestForNavigation
    }
  }
}
