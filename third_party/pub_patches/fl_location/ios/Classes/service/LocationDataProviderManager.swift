//
//  LocationDataProviderManager.swift
//  fl_location
//
//  Created by WOO JIN HWANG on 2021/08/06.
//

import Foundation

class LocationDataProviderManager: NSObject {
  private var providers = Dictionary<Int, LocationDataProvider>()
  
  private func buildLocationDataProvider() -> LocationDataProvider {
    return LocationDataProvider()
  }
  
  func getLocation(handler: LocationDataHandler, settings: LocationSettings) -> Int {
    let newLocationDataProvider = buildLocationDataProvider()
    let hashCode = newLocationDataProvider.hash
    providers[hashCode] = newLocationDataProvider
    
    let newHandler = LocationDataHandlerImplForManager(handler) {
      self.stopUpdatingLocation(hashCode: hashCode)
    }
    
    newLocationDataProvider.startUpdatingLocation(handler: newHandler, settings: settings)
    return hashCode
  }
  
  func startUpdatingLocation(handler: LocationDataHandler, settings: LocationSettings) -> Int {
    let newLocationDataProvider = buildLocationDataProvider()
    let hashCode = newLocationDataProvider.hash
    providers[hashCode] = newLocationDataProvider
    
    newLocationDataProvider.startUpdatingLocation(handler: handler, settings: settings)
    return hashCode
  }
  
  func stopUpdatingLocation(hashCode: Int) {
    guard let locationDataProvider = providers[hashCode] else { return }
    
    locationDataProvider.stopUpdatingLocation()
    providers.removeValue(forKey: hashCode)
  }
}
