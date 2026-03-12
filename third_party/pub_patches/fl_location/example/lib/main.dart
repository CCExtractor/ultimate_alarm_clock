import 'dart:async';
// import 'dart:io';

import 'package:fl_location/fl_location.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(ExampleApp());

enum ButtonState { LOADING, DONE, DISABLED }

class ExampleApp extends StatefulWidget {
  @override
  _ExampleAppState createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  StreamSubscription<Location>? _locationSubscription;

  String _result = '';
  ButtonState _getLocationButtonState = ButtonState.DONE;
  ButtonState _listenLocationStreamButtonState = ButtonState.DONE;

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

  void _refreshPage() {
    setState(() {});
  }

  Future<void> _getLocation() async {
    if (await _checkAndRequestPermission()) {
      _getLocationButtonState = ButtonState.LOADING;
      _listenLocationStreamButtonState = ButtonState.DISABLED;
      _refreshPage();

      final timeLimit = const Duration(seconds: 10);
      await FlLocation.getLocation(timeLimit: timeLimit).then((location) {
        _result = location.toJson().toString();
      }).onError((error, stackTrace) {
        _result = error.toString();
      }).whenComplete(() {
        _getLocationButtonState = ButtonState.DONE;
        _listenLocationStreamButtonState = ButtonState.DONE;
        _refreshPage();
      });
    }
  }

  Future<void> _listenLocationStream() async {
    if (await _checkAndRequestPermission()) {
      if (_locationSubscription != null) await _cancelLocationSubscription();

      _locationSubscription = FlLocation.getLocationStream()
          .handleError(_handleError)
          .listen((event) {
        _result = event.toJson().toString();
        _refreshPage();
      });

      _getLocationButtonState = ButtonState.DISABLED;
      _refreshPage();
    }
  }

  Future<void> _cancelLocationSubscription() async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;

    _getLocationButtonState = ButtonState.DONE;
    _refreshPage();
  }

  void _handleError(dynamic error, StackTrace stackTrace) {
    _result = error.toString();
    _refreshPage();
  }

  @override
  void initState() {
    super.initState();
    // The getLocationServicesStatusStream function is not available in Web.
    if (!kIsWeb) {
      FlLocation.getLocationServicesStatusStream().listen((event) {
        print('location services status: $event');
      });
    }
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: _buildContentView(),
      ),
    );
  }

  Widget _buildContentView() {
    final buttonList = Column(
      children: [
        const SizedBox(height: 8.0),
        _buildTestButton(
          text: 'GET Location',
          state: _getLocationButtonState,
          onPressed: _getLocation,
        ),
        const SizedBox(height: 8.0),
        _buildTestButton(
          text: _locationSubscription == null
              ? 'Listen LocationStream'
              : 'Cancel LocationSubscription',
          state: _listenLocationStreamButtonState,
          onPressed: _locationSubscription == null
              ? _listenLocationStream
              : _cancelLocationSubscription,
        ),
      ],
    );

    final resultText =
        Text(_result, style: Theme.of(context).textTheme.bodyText1);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      children: [
        buttonList,
        const SizedBox(height: 10.0),
        resultText,
      ],
    );
  }

  Widget _buildTestButton({
    required String text,
    required ButtonState state,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      child: state == ButtonState.LOADING
          ? SizedBox.fromSize(
              size: const Size(20.0, 20.0),
              child: const CircularProgressIndicator(strokeWidth: 2.0),
            )
          : Text(text),
      onPressed: state == ButtonState.DONE ? onPressed : null,
    );
  }
}
