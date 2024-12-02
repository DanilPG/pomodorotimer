import Foundation
import UserNotifications  //библиотека для работы с локальными уведомлениями

class PomodoroNotification {
  
  static func checkAuthorization(completion: @escaping (Bool) -> Void) {  //Проверяет статус разрешения для отправки уведомлений.
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.getNotificationSettings { settings in
      switch settings.authorizationStatus {
      case .authorized:
        completion(true)
      case .notDetermined:
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { allowed, error in
          completion(allowed)
        }
      default:
        completion(false)
      }
    }
  }
  
  static func scheduleNotification(seconds: TimeInterval, title: String, body: String) {
    let notificationCenter = UNUserNotificationCenter.current()

      //для избежания дублирующих уведомлений
    notificationCenter.removeAllDeliveredNotifications()
    notificationCenter.removeAllPendingNotificationRequests()

    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = .default
    content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: PomodoroAudioSounds.done.resource))

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false) //тригер активации уведомлений через заданный интервал секунд

    let request = UNNotificationRequest(identifier: "my-notification", content: content, trigger: trigger)
  
    notificationCenter.add(request)
  }
}

