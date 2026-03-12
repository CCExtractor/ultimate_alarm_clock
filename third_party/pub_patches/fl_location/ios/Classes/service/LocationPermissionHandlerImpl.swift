//
//  LocationPermissionHandlerImpl.swift
//  fl_location
//
//  Created by WOO JIN HWANG on 2021/08/09.
//

import Foundation

class LocationPermissionHandlerImpl: NSObject, LocationPermissionHandler {
  private let result: FlutterResult
  
  init(_ result: @escaping FlutterResult) {
    self.result = result
  }
  
  func onPermissionResult(locationPermission: LocationPermission) {
    result(locationPermission.rawValue)
  }
  
  func onPermissionError(errorCode: ErrorCodes) {
    ErrorHandleUtils.handleMethodCallError(result: result, errorCode: errorCode)
  }
}
