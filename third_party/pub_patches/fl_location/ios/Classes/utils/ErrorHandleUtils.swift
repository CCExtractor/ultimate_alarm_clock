//
//  ErrorHandleUtils.swift
//  fl_location
//
//  Created by WOO JIN HWANG on 2021/07/27.
//

import Flutter
import Foundation

class ErrorHandleUtils {
  static func handleMethodCallError(result: FlutterResult, errorCode: ErrorCodes) {
    let error = FlutterError(code: errorCode.rawValue, message: errorCode.message(), details: nil)
    result(error)
  }
  
  static func handleStreamError(events: FlutterEventSink, errorCode: ErrorCodes) {
    let error = FlutterError(code: errorCode.rawValue, message: errorCode.message(), details: nil)
    events(error)
  }
}
