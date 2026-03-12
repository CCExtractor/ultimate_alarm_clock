//
//  LocationPermissionManager.swift
//  fl_location
//
//  Created by WOO JIN HWANG on 2021/07/26.
//

import CoreLocation
import Foundation

class LocationPermissionManager: NSObject, CLLocationManagerDelegate {
  private let locationManager: CLLocationManager
  
  private var handler: LocationPermissionHandler? = nil
  
  override init() {
    self.locationManager = CLLocationManager()
    super.init()
    self.locationManager.delegate = self
  }
  
  func checkLocationPermission(handler: LocationPermissionHandler) {
    let status = CLLocationManager.authorizationStatus()
    let result = LocationPermission.fromAuthorizationStatus(status: status)
    handler.onPermissionResult(locationPermission: result)
  }
  
  func requestLocationPermission(handler: LocationPermissionHandler) {
    // The app has already requested location permission and is awaiting results.
    if self.handler != nil { return }
    
    self.handler = handler
    
    if containsLocationAlwaysUsageDescription() {
      locationManager.requestAlwaysAuthorization()
    } else if containsLocationWhenInUseUsageDescription() {
      locationManager.requestWhenInUseAuthorization()
    } else {
      handler.onPermissionError(errorCode: ErrorCodes.LOCATION_USAGE_DESCRIPTION_NOT_FOUND)
      disposeResources()
    }
  }
  
  func containsLocationAlwaysUsageDescription() -> Bool {
    if #available(iOS 11.0, *) {
      return Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysAndWhenInUseUsageDescription") != nil
    } else {
      return Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysUsageDescription") != nil
    }
  }
  
  func containsLocationWhenInUseUsageDescription() -> Bool {
    return Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") != nil
  }
  
  private func disposeResources() {
    self.handler = nil
  }
  
  @available(iOS, introduced: 4.2, deprecated: 14.0)
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if handler == nil { return }
    
    checkLocationPermission(handler: handler!)
    disposeResources()
  }
  
  @available(iOS 14.0, *)
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    if handler == nil { return }
    
    checkLocationPermission(handler: handler!)
    disposeResources()
  }
}
