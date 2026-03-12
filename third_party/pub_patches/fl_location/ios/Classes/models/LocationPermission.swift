//
//  LocationPermission.swift
//  fl_location
//
//  Created by WOO JIN HWANG on 2021/07/26.
//

import CoreLocation
import Foundation

enum LocationPermission: Int {
  case ALWAYS = 0
  case WHILE_IN_USE = 1
  case DENIED = 2
  case DENIED_FOREVER = 3
  
  static func fromAuthorizationStatus(status: CLAuthorizationStatus) -> LocationPermission {
    switch status {
      case .authorizedAlways:
        return LocationPermission.ALWAYS
      case .authorizedWhenInUse:
        return LocationPermission.WHILE_IN_USE
      case .notDetermined, .restricted:
        return LocationPermission.DENIED
      case .denied:
        return LocationPermission.DENIED_FOREVER
      default:
        return LocationPermission.DENIED
    }
  }
}
