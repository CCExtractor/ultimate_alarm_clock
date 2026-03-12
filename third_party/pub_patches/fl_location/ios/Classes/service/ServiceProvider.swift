//
//  ServiceProvider.swift
//  fl_location
//
//  Created by WOO JIN HWANG on 2021/07/27.
//

import Foundation

protocol ServiceProvider {
  func getLocationPermissionManager() -> LocationPermissionManager
  func getLocationDataProviderManager() -> LocationDataProviderManager
  func getLocationServicesStatusWatcher() -> LocationServicesStatusWatcher
}
