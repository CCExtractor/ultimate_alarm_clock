//
//  LocationPermissionHandler.swift
//  fl_location
//
//  Created by WOO JIN HWANG on 2021/07/29.
//

import Foundation

protocol LocationPermissionHandler {
  func onPermissionResult(locationPermission: LocationPermission)
  func onPermissionError(errorCode: ErrorCodes)
}
