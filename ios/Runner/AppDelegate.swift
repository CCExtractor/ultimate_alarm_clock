import UIKit
import Flutter
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(name: "ulticlock", binaryMessenger: controller.binaryMessenger)

      channel.setMethodCallHandler { [weak self] (call, result) in
        guard let self = self else { return }

        switch call.method {
        case "scheduleAlarm":
          if let args = call.arguments as? [String: Any], let milliseconds = args["milliSeconds"] as? Int {
            self.requestNotificationPermission { granted in
              if granted {
                self.scheduleAlarm(milliseconds: milliseconds, result: result)
              } else {
                result(FlutterError(code: "PERMISSION_DENIED", message: "User denied notifications permission", details: nil))
              }
            }
          } else {
            result(FlutterError(code: "BAD_ARGS", message: "Wrong arguments for scheduling an alarm", details: nil))
          }
        case "cancelAllScheduledAlarms":
          self.cancelAllScheduledAlarms()
          result(nil)
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func requestNotificationPermission(completion: @escaping (_ granted: Bool) -> Void) {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
      completion(granted)
    }
  }

  private func scheduleAlarm(milliseconds: Int, result: @escaping FlutterResult) {
    let content = UNMutableNotificationContent()
    content.title = "Alarm"
    content.body = "Your alarm is ringing!"
    content.sound = UNNotificationSound.default

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(milliseconds) / 1000, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { error in
      DispatchQueue.main.async {
        if let error = error {
          result(FlutterError(code: "ERR_ALARM", message: "Failed to schedule alarm", details: error.localizedDescription))
        } else {
          result(nil)
        }
      }
    }
  }

  private func cancelAllScheduledAlarms() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
  }
}
