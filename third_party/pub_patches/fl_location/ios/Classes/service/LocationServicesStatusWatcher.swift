//
//  LocationServicesStatusWatcher.swift
//  fl_location
//
//  Created by WOO JIN HWANG on 2021/07/27.
//

import CoreLocation
import Foundation

typealias LocationServicesStatusChangeHandler = (LocationServicesStatus) -> Void

class LocationServicesStatusWatcher: NSObject, CLLocationManagerDelegate {
  private let locationManager: CLLocationManager
  
  private var handler: LocationServicesStatusChangeHandler? = nil
  private var prevLocationServicesStatus: LocationServicesStatus? = nil
  
  override init() {
    self.locationManager = CLLocationManager()
    super.init()
    self.locationManager.delegate = self
  }
  
  func start(handler: @escaping LocationServicesStatusChangeHandler) {
    if self.handler != nil { stop() }
    
    self.handler = handler
    self.prevLocationServicesStatus = LocationServicesUtils.checkLocationServicesStatus()
  }
  
  func stop() {
    self.handler = nil
    self.prevLocationServicesStatus = nil
  }
  
  func checkLocationServicesStatusChange(handler: LocationServicesStatusChangeHandler) {
    let currLocationServicesStatus = LocationServicesUtils.checkLocationServicesStatus()
    if currLocationServicesStatus == prevLocationServicesStatus { return }
    
    handler(currLocationServicesStatus)
    prevLocationServicesStatus = currLocationServicesStatus
  }
  
  @available(iOS, introduced: 4.2, deprecated: 14.0)
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if handler == nil { return }
    
    checkLocationServicesStatusChange(handler: handler!)
  }
  
  @available(iOS 14.0, *)
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    if handler == nil { return }
    
    checkLocationServicesStatusChange(handler: handler!)
  }
}
