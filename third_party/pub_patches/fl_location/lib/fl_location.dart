import 'package:fl_location_platform_interface/fl_location_platform_interface.dart';
export 'package:fl_location_platform_interface/fl_location_platform_interface.dart';

class FlLocation {
  /// Whether location services are enabled.
  static Future<bool> get isLocationServicesEnabled =>
      FlLocationPlatform.instance.isLocationServicesEnabled();

  /// Check location permission.
  static Future<LocationPermission> checkLocationPermission() =>
      FlLocationPlatform.instance.checkLocationPermission();

  /// Request location permission.
  static Future<LocationPermission> requestLocationPermission() =>
      FlLocationPlatform.instance.requestLocationPermission();

  /// Get the current location.
  static Future<Location> getLocation({
    LocationAccuracy accuracy = LocationAccuracy.best,
    Duration? timeLimit,
  }) =>
      FlLocationPlatform.instance
          .getLocation(accuracy: accuracy, timeLimit: timeLimit);

  /// Get the location stream.
  static Stream<Location> getLocationStream({
    LocationAccuracy accuracy = LocationAccuracy.best,
    int interval = 5000,
    double distanceFilter = 0.0,
  }) =>
      FlLocationPlatform.instance.getLocationStream(
          accuracy: accuracy,
          interval: interval,
          distanceFilter: distanceFilter);

  /// Get the location services status stream.
  static Stream<LocationServicesStatus> getLocationServicesStatusStream() =>
      FlLocationPlatform.instance.getLocationServicesStatusStream();
}
