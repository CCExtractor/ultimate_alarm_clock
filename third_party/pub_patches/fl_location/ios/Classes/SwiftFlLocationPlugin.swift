import Flutter
import UIKit

public class SwiftFlLocationPlugin: NSObject, FlutterPlugin, ServiceProvider {
  private var locationPermissionManager: LocationPermissionManager? = nil
  private var locationDataProviderManager: LocationDataProviderManager? = nil
  private var locationServicesStatusWatcher: LocationServicesStatusWatcher? = nil
  
  private var methodCallHandler: MethodCallHandlerImpl? = nil
  private var locationStreamHandler: LocationStreamHandlerImpl? = nil
  private var locationServicesStatusStreamHandler: LocationServicesStatusStreamHandlerImpl? = nil

  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = SwiftFlLocationPlugin()
    instance.initServices()
    instance.initChannels(registrar.messenger())
  }

  private func initServices() {
    locationPermissionManager = LocationPermissionManager()
    locationDataProviderManager = LocationDataProviderManager()
    locationServicesStatusWatcher = LocationServicesStatusWatcher()
  }
  
  private func initChannels(_ messenger: FlutterBinaryMessenger) {
    methodCallHandler = MethodCallHandlerImpl(messenger: messenger, serviceProvider: self)
    locationStreamHandler = LocationStreamHandlerImpl(messenger: messenger, serviceProvider: self)
    locationServicesStatusStreamHandler = LocationServicesStatusStreamHandlerImpl(messenger: messenger, serviceProvider: self)
  }
  
  func getLocationPermissionManager() -> LocationPermissionManager { return locationPermissionManager! }
  
  func getLocationDataProviderManager() -> LocationDataProviderManager { return locationDataProviderManager! }
  
  func getLocationServicesStatusWatcher() -> LocationServicesStatusWatcher { return locationServicesStatusWatcher! }
}
