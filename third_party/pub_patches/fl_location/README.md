# fl_location

A plugin that can access the location services of each platform and collect device location data.

## Platform

- [x] Android
- [x] iOS
- [x] Web

## Features

* Can request location permission.
* Can get the current location of the device.
* Can check whether location services are enabled.
* Can subscribe to `LocationStream` to collect location data in real time.
* Can subscribe to `LocationServicesStatusStream` to listen location services status changes in real time.

## Getting started

To use this plugin, add `fl_location` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/). For example:

```yaml
dependencies:
  fl_location: ^2.1.1
```

After adding the `fl_location` plugin to the flutter project, we need to specify the platform-specific permissions for this plugin to work properly.

### :baby_chick: Android

Since this plugin works based on location, we need to add the following permission to the `AndroidManifest.xml` file. Open the `AndroidManifest.xml` file and specify it between the `<manifest>` and `<application>` tags.

```
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

If you want to get the location in the background, add the following permission. If your project supports Android 10, be sure to add the `ACCESS_BACKGROUND_LOCATION` permission.

```
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
```

### :baby_chick: iOS

Like the Android platform, this plugin works based on location, we need to add the following description. Open the `ios/Runner/Info.plist` file and specify it inside the `<dict>` tag.

```
<key>NSLocationWhenInUseUsageDescription</key>
<string>Used to collect location data.</string>
```

If you want to get the location in the background, add the following description.

```
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Used to collect location data in the background.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>Used to collect location data in the background.</string>
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>location</string>
</array>
```

## How to use

1. Check whether the location permission is allowed or not, and if not allowed, request the location permission.

```dart
Future<bool> _checkAndRequestPermission({bool? background}) async {
  if (!await FlLocation.isLocationServicesEnabled) {
    // Location services are disabled.
    return false;
  }

  var locationPermission = await FlLocation.checkLocationPermission();
  if (locationPermission == LocationPermission.deniedForever) {
    // Cannot request runtime permission because location permission is denied forever.
    return false;
  } else if (locationPermission == LocationPermission.denied) {
    // Ask the user for location permission.
    locationPermission = await FlLocation.requestLocationPermission();
    if (locationPermission == LocationPermission.denied ||
        locationPermission == LocationPermission.deniedForever) return false;
  }

  // Location permission must always be allowed (LocationPermission.always)
  // to collect location data in the background.
  if (background == true &&
      locationPermission == LocationPermission.whileInUse) return false;

  // Location services has been enabled and permission have been granted.
  return true;
}
```

2. To get the current location, use the `getLocation` function.

```dart
Future<void> _getLocation() async {
  if (await _checkAndRequestPermission()) {
    final timeLimit = const Duration(seconds: 10);
    await FlLocation.getLocation(timeLimit: timeLimit).then((location) {
      print('location: ${location.toJson().toString()}');
    }).onError((error, stackTrace) {
      print('error: ${error.toString()}');
    });
  }
}
```

3. To collect location data in real time, use the `getLocationStream` function.

```dart
StreamSubscription<Location>? _locationSubscription;

Future<void> _listenLocationStream() async {
  if (await _checkAndRequestPermission()) {
    if (_locationSubscription != null) await _cancelLocationSubscription();

    _locationSubscription = FlLocation.getLocationStream()
        .handleError(_handleError)
        .listen((event) {
      print('location: ${event.toJson().toString()}');
    });
  }
}

Future<void> _cancelLocationSubscription() async {
  await _locationSubscription?.cancel();
  _locationSubscription = null;
}

void _handleError(dynamic error, StackTrace stackTrace) {
  print('error: ${error.toString()}');
}
```

4. To listen location services status changes in real time, use the `getLocationServicesStatusStream` function.

```dart
StreamSubscription<LocationServicesStatus>? _locationServicesStatusSubscription;

Future<void> _listenLocationServicesStatusStream() async {
  if (_locationServicesStatusSubscription != null)
    await _cancelLocationServicesStatusSubscription();

  _locationServicesStatusSubscription =
      FlLocation.getLocationServicesStatusStream().listen((event) {
    print('location services status: $event');
  });
}

Future<void> _cancelLocationServicesStatusSubscription() async {
  await _locationServicesStatusSubscription?.cancel();
  _locationServicesStatusSubscription = null;
}
```

## Models

### :chicken: Location

A data class that represents a location model.

| Field | Description |
|---|---|
| `latitude` | The latitude of the location. |
| `longitude` | The longitude of the location. |
| `accuracy` | The accuracy of the location. |
| `altitude` | The altitude of the location. |
| `heading` | The angle in the direction the device is moving. |
| `speed` | The movement speed of the device. |
| `speedAccuracy` | The accuracy of `speed`. |
| `millisecondsSinceEpoch` | The millisecondsSinceEpoch at which the location update occurred. |
| `timestamp` | The device time at which the location update occurred. |
| `isMock` | Whether the mock location. |

### :chicken: LocationAccuracy

An enumeration of location accuracy.

| Value | Description |
|---|---|
| `powerSave` | The location has an accuracy of 10km on Android and 3km on iOS. |
| `low` | The location has an accuracy of 10km on Android and 1km on iOS. |
| `balanced` | The location has an accuracy of 100m for both Android and iOS. |
| `high` | The location has an accuracy of ~100m on Android and 10m on iOS. |
| `best` | The location has an accuracy of ~100m on Android and ~10m on iOS. |
| `navigation` | The location has an accuracy of ~100m on Android and optimized for navigation on iOS. |

### :chicken: LocationPermission

An enumeration of location permission.

| Value | Description |
|---|---|
| `always` | The app can read location at any time. The app need this permission to read location in the background. |
| `whileInUse` | The location can only be read while using the app. |
| `denied` | The location cannot be read because permission is denied. The app can request runtime permissions again. |
| `deniedForever` | The location cannot be read because permission is denied. The app can no longer request runtime permissions and must grant permissions manually. |

### :chicken: LocationServicesStatus

An enumeration of location services status.

| Value | Description |
|---|---|
| `enabled` | Location services are enabled. |
| `disabled` | Location services are disabled. |

## Support

If you find any bugs or issues while using the plugin, please register an issues on [GitHub](https://github.com/Dev-hwang/flutter_location/issues). You can also contact us at <hwj930513@naver.com>.
