import Cocoa
import FlutterMacOS
import AVFoundation

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
    let CHANNEL1 = "ulticlock"
    let CHANNEL2 = "timer"
    let ACTION_START_FLUTTER_APP = "com.ccextractor.ultimate_alarm_clock"
    let EXTRA_KEY = "alarmRing"
    let ALARM_TYPE = "isAlarm"
    var isAlarm: String? = "true"
    var alarmConfig: [String: Bool] = ["shouldAlarmRing": false, "alarmIgnore": false]
    var ringtone: AVAudioPlayer? = nil

    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        
        let methodChannel1 = FlutterMethodChannel(name: CHANNEL1, binaryMessenger: flutterViewController.engine.binaryMessenger)
        let methodChannel2 = FlutterMethodChannel(name: CHANNEL2, binaryMessenger: flutterViewController.engine.binaryMessenger)
        
        // Retrieve alarm data from UserDefaults (simulating intent extras)
//        if let receivedData = UserDefaults.standard.string(forKey: EXTRA_KEY) {
//            if receivedData == "true" {
//                alarmConfig["shouldAlarmRing"] = true
//            }
//            isAlarm = UserDefaults.standard.string(forKey: ALARM_TYPE)
//            
//            // Clear stored intent data to prevent re-triggering
//            UserDefaults.standard.removeObject(forKey: EXTRA_KEY)
//            UserDefaults.standard.synchronize()
//            
//            print("NATIVE SAID OK")
//        } else {
//            print("NATIVE SAID NO")
//        }
        
//        if isAlarm == "true" {
//            UserDefaults.standard.removeObject(forKey: EXTRA_KEY)
//            methodChannel1.invokeMethod("appStartup", arguments: alarmConfig)
//            alarmConfig["shouldAlarmRing"] = false
//        }


        methodChannel1.setMethodCallHandler({
          [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
          // This method is invoked on the UI thread.
            if (call.method == "scheduleAlarm") {
//                println("FLUTTER CALLED SCHEDULE")
//                val dbHelper = DatabaseHelper(context)
//                val db = dbHelper.readableDatabase
//                val sharedPreferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
//                val profile = sharedPreferences.getString("flutter.profile", "Default")
//                val ringTime = getLatestAlarm(db, true, profile?: "Default")
//                Log.d("yay yay", "yay ${ringTime?:"null"}")
//                if (ringTime != null) {
//                    android.util.Log.d("yay", "yay ${ringTime["interval"]}")
//                    Log.d("yay", "yay ${ringTime["isLocation"]}")
//                    scheduleAlarm(
//                        ringTime["interval"]!! as Long,
//                        ringTime["isActivity"]!! as Int,
//                        ringTime["isLocation"]!! as Int,
//                        ringTime["location"]!! as String,
//                        ringTime["isWeather"]!! as Int,
//                        ringTime["weatherTypes"]!! as String
//                    )
//                }else{
//                    println("FLUTTER CALLED CANCEL ALARMS")
//                    cancelAllScheduledAlarms()
//                }
//                result.success(null)
                
                print("FLUTTER CALLED SCHEDULE")

                let profile = self.sharedPrefs.string(forKey: "flutter.profile") ?? "Default"
                if let ringTime = self.getLatestAlarm(profile: profile) {
                    print("yay yay \(ringTime)")

                    self.scheduleAlarm(
                        interval: ringTime["interval"] as! Int64,
                        isActivity: ringTime["isActivity"] as! Int,
                        isLocation: ringTime["isLocation"] as! Int,
                        location: ringTime["location"] as! String,
                        isWeather: ringTime["isWeather"] as! Int,
                        weatherTypes: ringTime["weatherTypes"] as! String
                    )
                } else {
                    print("FLUTTER CALLED CANCEL ALARMS")
                    self.cancelAllScheduledAlarms()
                }
                result(nil)
            } else if (call.method == "cancelAllScheduledAlarms") {
                print("FLUTTER CALLED CANCEL ALARMS")
                cancelAllScheduledAlarms()
                result(nil)
            } else if (call.method == "bringAppToForeground") {
                bringAppToForeground(this)
                result(nil)
            } else if (call.method == "minimizeApp") {
                minimizeApp()
                result(nil)
            } else if (call.method == "playDefaultAlarm") {
                playDefaultAlarm(this)
                result(nil)
            } else if (call.method == "stopDefaultAlarm") {
                stopDefaultAlarm()
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
                return
            }
        })
        
        methodChannel2.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
            
            if (call.method == "playDefaultAlarm") {
                playDefaultAlarm(this)
                result(nil)
            } else if (call.method == "stopDefaultAlarm") {
                stopDefaultAlarm()
                result(nil)
            } else if (call.method == "runtimerNotif") {
                val startTimerIntent =
                    Intent("com.ccextractor.ultimate_alarm_clock.START_TIMERNOTIF")
                context.sendBroadcast(startTimerIntent)
                result(nil)
            } else if (call.method == "clearTimerNotif") {
                val stopTimerIntent = Intent("com.ccextractor.ultimate_alarm_clock.STOP_TIMERNOTIF")
                context.sendBroadcast(stopTimerIntent)
                var notificationManager =
                    context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                notificationManager.cancel(1)
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
                return
            }
        })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  private func receiveBatteryLevel(result: FlutterResult) {
    let device = UIDevice.current
    device.isBatteryMonitoringEnabled = true
    if device.batteryState == UIDevice.BatteryState.unknown {
      result(FlutterError(code: "UNAVAILABLE",
                          message: "Battery level not available.",
                          details: nil))
    } else {
      result(Int(device.batteryLevel * 100))
    }
  }
}
