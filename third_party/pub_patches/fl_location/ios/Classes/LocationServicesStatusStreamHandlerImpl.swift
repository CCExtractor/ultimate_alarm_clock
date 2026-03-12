//
//  LocationServicesStatusStreamHandlerImpl.swift
//  fl_location
//
//  Created by WOO JIN HWANG on 2021/07/27.
//

import Flutter
import Foundation

class LocationServicesStatusStreamHandlerImpl: NSObject, FlutterStreamHandler {
  private let channel: FlutterEventChannel
  private let serviceProvider: ServiceProvider
  
  init(messenger: FlutterBinaryMessenger, serviceProvider: ServiceProvider) {
    self.serviceProvider = serviceProvider
    self.channel = FlutterEventChannel(name: "plugins.pravera.com/fl_location/location_services_status", binaryMessenger: messenger)
    super.init()
    self.channel.setStreamHandler(self)
  }
  
  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    serviceProvider.getLocationServicesStatusWatcher().start { (locationServicesStatus) in
      events(locationServicesStatus.rawValue)
    }
    return nil
  }
  
  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    serviceProvider.getLocationServicesStatusWatcher().stop()
    return nil
  }
}
