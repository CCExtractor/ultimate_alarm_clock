//
//  LocationServicesUtils.swift
//  fl_location
//
//  Created by WOO JIN HWANG on 2021/07/26.
//

import CoreLocation
import Foundation

class LocationServicesUtils {
  static func checkLocationServicesStatus() -> LocationServicesStatus {
    if CLLocationManager.locationServicesEnabled() {
      return LocationServicesStatus.ENABLED
    } else {
      return LocationServicesStatus.DISABLED
    }
  }
}
