import Cocoa
import FlutterMacOS
import IOKit.ps
import AVFoundation
import AppKit
import UserNotifications

class MainFlutterWindow: NSWindow {
    static let CHANNEL1 = "ulticlock"
    static let CHANNEL2 = "timer"
    static let ACTION_START_FLUTTER_APP = "com.ccextractor.ultimate_alarm_clock"
    static let EXTRA_KEY = "alarmRing"
    static let ALARM_TYPE = "isAlarm"
    
    private static var isAlarm: String? = "true"
    static var alarmConfig: [String: Bool] = ["shouldAlarmRing": false, "alarmIgnore": false]
    private static var audioPlayer: AVAudioPlayer?
    private static let userNotification = UNUserNotificationCenter.current()
    
    override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)
        
    self.requestNotificationAuth()
      
    let methodChannel1 = FlutterMethodChannel(
        name: MainFlutterWindow.CHANNEL1,
        binaryMessenger: flutterViewController.engine.binaryMessenger
    )
    let methodChannel2 = FlutterMethodChannel(
        name: MainFlutterWindow.CHANNEL2,
      binaryMessenger: flutterViewController.engine.binaryMessenger
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
                self.bringAppToForeground()
                result(nil)
            case "minimizeApp":
                print("APP MINIMIZED")
                self.minimizeApp()
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
            self.scheduleNotificationAlarm(after: 10)
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

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
    }
    
    private func playDefaultAlarm() {
        guard let soundURL = Bundle.main.url(forResource: "digialarm", withExtension: "mp3") else {
            print("Alarm sound file not found")
            return
        }
        
        do {
            MainFlutterWindow.audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            MainFlutterWindow.audioPlayer?.numberOfLoops = -1 // Loop indefinitely
            MainFlutterWindow.audioPlayer?.prepareToPlay()
            MainFlutterWindow.audioPlayer?.play()
        } catch {
            print("Error playing alarm sound: \(error.localizedDescription)")
        }
    }
    
    private func stopDefaultAlarm() {
        MainFlutterWindow.audioPlayer?.stop()
    }
    
    private func bringAppToForeground() {
        NSApplication.shared.activate(ignoringOtherApps: true)
    }
    
    private func minimizeApp() {
        NSApplication.shared.hide(self)
    }
    
    private func requestNotificationAuth() {
        MainFlutterWindow.userNotification.requestAuthorization(options: [.alert, .sound]) {(authorized, error) in
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
    
    private func scheduleNotificationAlarm(after seconds: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "⏰ Alarm!"
        content.body = "Time to wake up!"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: "AlarmNotification", content: content, trigger: trigger)

        MainFlutterWindow.userNotification.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
        
        print("ALARM NOTIFICATION")
    }

}
