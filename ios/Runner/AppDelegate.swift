import Flutter
import UIKit
import AVFoundation
import UserNotifications

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
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      self.requestNotificationAuth()
      
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
                  print("FLUTTER CALLED SCHEDULE")
                  result(nil)
              case "cancelAllScheduledAlarms":
                  print("FLUTTER CALLED CANCEL ALARMS")
                  result(nil)
              case "bringAppToForeground":
                  print("BRING APP FOREGROUND")
                  //self.bringAppToForeground()
                  result(nil)
              case "minimizeApp":
                  print("APP MINIMIZED")
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
              print("RUNTIMER NOTIF CALLED")
              result(nil)
          case "clearTimerNotif":
              // TODO
              print("CLEAR TIMER NOTIF")
              result(nil)
          default:
              result(FlutterMethodNotImplemented)
          }
      }
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func playDefaultAlarm() {
            guard let soundURL = Bundle.main.url(forResource: "digialarm", withExtension: "mp3") else {
                print("Alarm sound file not found")
                return
            }

            do {
                AppDelegate.audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                AppDelegate.audioPlayer?.numberOfLoops = -1 // Loop indefinitely
                AppDelegate.audioPlayer?.prepareToPlay()
                AppDelegate.audioPlayer?.play()
            } catch {
                print("Error playing alarm sound: \(error.localizedDescription)")
            }
            print("TIMER ALERT PLAYING")
        }

        private func stopDefaultAlarm() {
            AppDelegate.audioPlayer?.stop()
            print("TIMER ALERT STOPPED")
        }

        private func requestNotificationAuth() {
            AppDelegate.userNotification.requestAuthorization(options: [.alert, .sound, .badge]) {(authorized, error) in
                if authorized {
                    print("NOTIFICATION AUTHORIZED")
                }
                else if !authorized {
                    print("NOT AUTHORIZED")
                }
                else {
                    print(error?.localizedDescription as Any)
                }
            }
        }
}
