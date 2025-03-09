import Flutter
import UIKit
import AVFoundation
import UserNotifications
import FMDB
import BackgroundTasks

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    static let CHANNEL1 = "ulticlock"
    static let CHANNEL2 = "timer"
    static let ACTION_START_FLUTTER_APP = "com.ccextractor.ultimate_alarm_clock"
    static let EXTRA_KEY = "alarmRing"
    static let ALARM_TYPE = "isAlarm"

    private static var isAlarm: String? = "true"
    static var alarmConfig: [String: Bool] = ["shouldAlarmRing": false, "alarmIgnore": false]
    private static var audioPlayer: AVAudioPlayer?
    private static let userNotification = UNUserNotificationCenter.current()
    private static let operationQueue = OperationQueue()
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      self.requestNotificationAuth()
      
      AppDelegate.userNotification.delegate = self
      
      NSLog("Log:HERE I AM")
      
      BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.ccextractor.ultimateAlarmClock.Runner.refresh", using: nil) { task in
           self.handleAppRefresh(task: task as! BGAppRefreshTask)
      }
      
      let methodChannel1 = FlutterMethodChannel(
        name: AppDelegate.CHANNEL1,
        binaryMessenger: controller.binaryMessenger
      )
      let methodChannel2 = FlutterMethodChannel(
        name: AppDelegate.CHANNEL2,
        binaryMessenger: controller.binaryMessenger
      )
      
      methodChannel1.setMethodCallHandler { (call, result) in
          switch call.method {
          case "scheduleAlarm":
              NSLog("Log:FLUTTER CALLED SCHEDULE")
              var dbHelper: DatabaseHelper = DatabaseHelper()
              var db: FMDatabase? = dbHelper.database
              
              let sharedDefaults = UserDefaults.standard
              let profile = sharedDefaults.string(forKey: "flutter.profile") ?? "Default"
              NSLog("Log:Profile: \(profile)")
              
              var ringTime: [String: Any]? = getLatestAlarm(db: db, profile: profile)
              
              guard let interval = ringTime?["interval"] else {
                  NSLog("Log:Something Wrong")
                  NSLog("FLUTTER CALLED CANCEL ALARMS")
                  self.cancelAllScheduledAlarms()
                  return
              }
              guard let ringTime = ringTime else {
                  NSLog("Log:FLUTTER CALLED CANCEL ALARMS")
                  self.cancelAllScheduledAlarms()
                  return
              }
              NSLog("Log:TIME TO ALARM(seconds): \(interval)")
              self.scheduleAlarm(
                alarmID: ringTime["alarmID"] as! String,
                interval: ringTime["interval"] as! Double,
                isActivity: ringTime["isActivity"] as! Bool,
                isLocation: ringTime["isLocation"] as! Bool,
                location: ringTime["location"] as! String,
                isWeather: ringTime["isWeather"] as! Bool,
                weatherTypes: ringTime["weatherTypes"] as! String
              )
              self.scheduleNotification(
                uuid: ringTime["alarmID"] as! String,
                title: "Test Alarm",
                body: "Don't wake up, it's a test alarm",
                interval: ringTime["interval"] as! Double
              )
              
              result(nil)
          case "cancelAllScheduledAlarms":
              NSLog("Log:FLUTTER CALLED CANCEL ALARMS")
              self.cancelAllScheduledAlarms()
              result(nil)
          case "bringAppToForeground":
              NSLog("Log:BRING APP FOREGROUND")
              //self.bringAppToForeground()
              result(nil)
          case "minimizeApp":
              NSLog("Log:APP MINIMIZED")
              //self.minimizeApp()
              result(nil)
          case "playDefaultAlarm":
              self.playDefaultAlarm()
              result(nil)
          case "stopDefaultAlarm":
              self.stopDefaultAlarm()
              result(nil)
          default:
              result(FlutterMethodNotImplemented)
          }
      }
      
      methodChannel2.setMethodCallHandler { (call, result) in
          switch call.method{
          case "playDefaultAlarm":
              self.playDefaultAlarm()
              result(nil)
          case "stopDefaultAlarm":
              self.stopDefaultAlarm()
              result(nil)
          case "runtimerNotif":
              // TODO
              NSLog("Log:RUNTIMER NOTIF CALLED")
              result(nil)
          case "clearTimerNotif":
              // TODO
              NSLog("Log:CLEAR TIMER NOTIF")
              result(nil)
          default:
              result(FlutterMethodNotImplemented)
          }
      }
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func scheduleAppRefresh() {
       let request = BGAppRefreshTaskRequest(identifier: "com.ccextractor.ultimateAlarmClock.Runner.refresh")
       // Fetch no earlier than 15 minutes from now.
       request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
            
       do {
          try BGTaskScheduler.shared.submit(request)
       } catch {
          NSLog("Log:Could not schedule app refresh: \(error)")
       }
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
       // Schedule a new refresh task.
        self.scheduleAppRefresh()


       // Create an operation that performs the main part of the background task.
       let operation = RefreshAppContentsOperation()
       
       // Provide the background task with an expiration handler that cancels the operation.
       task.expirationHandler = {
          operation.cancel()
       }


       // Inform the system that the background task is complete
       // when the operation completes.
       operation.completionBlock = {
          task.setTaskCompleted(success: !operation.isCancelled)
       }


       // Start the operation.
        AppDelegate.operationQueue.addOperation(operation)
     }
    
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        NSLog("Log:Notification Tapped: \(userInfo)")

        // Call your method
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(
          name: AppDelegate.CHANNEL1,
          binaryMessenger: controller.binaryMessenger
        )
        let arguments: [String: Bool] = [
            "alarmRing": true,
            "isAlarm": true,
            "shouldAlarmRing": true,
            "alarmIgnore": false
        ]
        
        channel.invokeMethod("appStartup", arguments: arguments )

        completionHandler()
    }
    
    private func playDefaultAlarm() {
        guard let soundURL = Bundle.main.url(forResource: "digialarm", withExtension: "wav") else {
            NSLog("Log:Alarm sound file not found")
            return
        }

        do {
            AppDelegate.audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            AppDelegate.audioPlayer?.numberOfLoops = -1 // Loop indefinitely
            AppDelegate.audioPlayer?.prepareToPlay()
            AppDelegate.audioPlayer?.play()
        } catch {
            NSLog("Log:Error playing alarm sound: \(error.localizedDescription)")
        }
        NSLog("Log:TIMER ALERT PLAYING")
    }

    private func stopDefaultAlarm() {
        AppDelegate.audioPlayer?.stop()
        NSLog("Log:TIMER ALERT STOPPED")
    }

    private func requestNotificationAuth() {
        AppDelegate.userNotification.requestAuthorization(options: [.alert, .sound, .badge]) {(authorized, error) in
            if authorized {
                NSLog("Log:NOTIFICATION AUTHORIZED")
            }
            else if !authorized {
                NSLog("Log:NOT AUTHORIZED")
            }
            else {
                NSLog("Log:ERROR NOTIFICATION ACCESS")
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    private func scheduleAlarm(
        alarmID: String,
        interval: Double,
        isActivity: Bool,
        isLocation: Bool,
        location: String,
        isWeather: Bool,
        weatherTypes: String
    ) {}
    
    private func cancelAllScheduledAlarms() {
        AppDelegate.userNotification.removeAllPendingNotificationRequests()
        NSLog("Log:REMOVED ALL NOTIFICATION REQUESTS")
    }
    
    private func scheduleNotification(
        uuid: String,
        title: String,
        body: String,
        interval: Double
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        //content.sound = UNNotificationSound.default
        content.sound = UNNotificationSound(named: UNNotificationSoundName("digialarm.wav"))
        // intereption level only ios >= 15.0
        content.interruptionLevel = UNNotificationInterruptionLevel.timeSensitive
        content.userInfo = ["ID": "test"]
        
        for index in 0...60 {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval+Double(index*5), repeats: false)
            let request = UNNotificationRequest(identifier: uuid+String(index), content: content, trigger: trigger)
            
            do {
                try AppDelegate.userNotification.add(request, withCompletionHandler: nil)
            } catch {
                NSLog("Log:ERROR SCHEDULING NOTIFICATION AT INTERVAL: \(interval)")
                return
            }
        }
        
        NSLog("Log:ALARM SCHEDULED AFTER: \(interval) seconds")
    }
}
