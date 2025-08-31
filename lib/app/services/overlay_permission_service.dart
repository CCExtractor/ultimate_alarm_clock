import 'dart:io';
import 'package:flutter/services.dart';

class OverlayPermissionService {
  static const MethodChannel _channel = MethodChannel('ulticlock');

  /// Check if overlay permission is granted
  static Future<bool> isOverlayPermissionGranted() async {
    if (!Platform.isAndroid) return true; // Only relevant for Android
    
    try {
      final bool result = await _channel.invokeMethod('checkOverlayPermission');
      return result;
    } catch (e) {
      print('Error checking overlay permission: $e');
      return false;
    }
  }

  /// Request overlay permission
  static Future<bool> requestOverlayPermission() async {
    if (!Platform.isAndroid) return true; // Only relevant for Android
    
    try {
      final bool result = await _channel.invokeMethod('requestOverlayPermission');
      return result;
    } catch (e) {
      print('Error requesting overlay permission: $e');
      return false;
    }
  }

  /// Check and request permission if needed
  static Future<bool> ensureOverlayPermission() async {
    if (!Platform.isAndroid) return true;
    
    bool hasPermission = await isOverlayPermissionGranted();
    
    if (!hasPermission) {
      hasPermission = await requestOverlayPermission();
    }
    
    return hasPermission;
  }
}

