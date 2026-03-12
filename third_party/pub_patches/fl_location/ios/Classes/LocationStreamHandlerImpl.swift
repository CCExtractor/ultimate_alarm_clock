//
//  LocationStreamHandlerImpl.swift
//  fl_location
//
//  Created by WOO JIN HWANG on 2021/07/29.
//

import Flutter
import Foundation

class LocationStreamHandlerImpl: NSObject, FlutterStreamHandler, LocationDataHandler {
  private let channel: FlutterEventChannel
  private let serviceProvider: ServiceProvider
  
  private var locationEventSink: FlutterEventSink? = nil
  private var locationDataProviderHashCode: Int? = nil
  
  init(messenger: FlutterBinaryMessenger, serviceProvider: ServiceProvider) {
    self.serviceProvider = serviceProvider
    self.channel = FlutterEventChannel(name: "plugins.pravera.com/fl_location/updates", binaryMessenger: messenger)
    super.init()
    self.channel.setStreamHandler(self)
  }
  
  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    let argsDict = arguments as? Dictionary<String, Any>
    let settings = LocationSettings(from: argsDict)
    
    locationEventSink = events
    locationDataProviderHashCode = serviceProvider
      .getLocationDataProviderManager()
      .startUpdatingLocation(handler: self, settings: settings)
    return nil
  }
  
  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    locationEventSink = nil
    if locationDataProviderHashCode != nil {
      serviceProvider
        .getLocationDataProviderManager()
        .stopUpdatingLocation(hashCode: locationDataProviderHashCode!)
      locationDataProviderHashCode = nil
    }
    return nil
  }
  
  func onLocationUpdate(locationJson: String) {
    locationEventSink?(locationJson)
  }
  
  func onLocationError(errorCode: ErrorCodes) {
    if locationEventSink == nil { return }
    ErrorHandleUtils.handleStreamError(events: locationEventSink!, errorCode: errorCode)
  }
}
