//
//  LocationDataHandlerImpl.swift
//  fl_location
//
//  Created by WOO JIN HWANG on 2021/08/09.
//

import Foundation

class LocationDataHandlerImpl: NSObject, LocationDataHandler {
  private let result: FlutterResult
  
  init(_ result: @escaping FlutterResult) {
    self.result = result
  }
  
  func onLocationUpdate(locationJson: String) {
    result(locationJson)
  }
  
  func onLocationError(errorCode: ErrorCodes) {
    ErrorHandleUtils.handleMethodCallError(result: result, errorCode: errorCode)
  }
}
