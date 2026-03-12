//
//  LocationDataProvider.swift
//  fl_location
//
//  Created by WOO JIN HWANG on 2021/07/28.
//

import CoreLocation
import Foundation

class LocationDataProvider: NSObject, CLLocationManagerDelegate {
  private let jsonEncoder: JSONEncoder
  private let locationManager: CLLocationManager
  
  private var handler: LocationDataHandler? = nil
  private var settings: LocationSettings? = nil
  
  override init() {
    self.jsonEncoder = JSONEncoder()
    self.locationManager = CLLocationManager()
    super.init()
    self.locationManager.delegate = self
  }
  
  func startUpdatingLocation(handler: LocationDataHandler, settings: LocationSettings) {
    if self.handler != nil { stopUpdatingLocation() }
    
    self.handler = handler
    self.settings = settings
    
    self.locationManager.desiredAccuracy = settings.accuracy.toCLLocationAccuracy()
    self.locationManager.distanceFilter = settings.distanceFilter ?? kCLDistanceFilterNone
    self.locationManager.allowsBackgroundLocationUpdates = containsBackgroundLocationMode()
    
    self.locationManager.startUpdatingLocation()
  }
  
  func stopUpdatingLocation() {
    self.locationManager.stopUpdatingLocation()
    
    self.handler = nil
    self.settings = nil
  }
  
  func containsBackgroundLocationMode() -> Bool {
    let backgroundModes = Bundle.main.object(forInfoDictionaryKey: "UIBackgroundModes") as? NSArray
    return backgroundModes?.contains("location") ?? false
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if handler == nil { return }
    
    do {
      let locationData = LocationData(from: locations.last!)
      guard let locationJson = String(data: try jsonEncoder.encode(locationData), encoding: .utf8) else { return }
      handler?.onLocationUpdate(locationJson: locationJson)
    } catch {
      handler?.onLocationError(errorCode: ErrorCodes.LOCATION_DATA_ENCODING_FAILED)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    if handler == nil { return }
    
    NSLog("LOCATION_UPDATE_FAILED: \(error)")
    handler?.onLocationError(errorCode: ErrorCodes.LOCATION_UPDATE_FAILED)
  }
}
