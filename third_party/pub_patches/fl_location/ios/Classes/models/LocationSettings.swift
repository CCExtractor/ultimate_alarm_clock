//
//  LocationSettings.swift
//  fl_location
//
//  Created by WOO JIN HWANG on 2021/07/29.
//

import Foundation

class LocationSettings {
  let accuracy: LocationAccuracy
  let interval: Int?
  let distanceFilter: Double?
  
  init(from dictionary: Dictionary<String, Any>?) {
    let rAccuracy = dictionary?["accuracy"] as? Int ?? LocationAccuracy.BEST.rawValue
    let rInterval = dictionary?["interval"] as? Int
    let rDistanceFilter = dictionary?["distanceFilter"] as? Double
    
    self.accuracy = LocationAccuracy.fromIndex(index: rAccuracy)
    self.interval = rInterval
    self.distanceFilter = rDistanceFilter
  }
}
