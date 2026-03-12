//
//  LocationDataHandler.swift
//  fl_location
//
//  Created by WOO JIN HWANG on 2021/07/29.
//

import Foundation

protocol LocationDataHandler {
  func onLocationUpdate(locationJson: String)
  func onLocationError(errorCode: ErrorCodes)
}
