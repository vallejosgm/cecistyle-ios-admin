//
//  NotificationDelegate.swift
//  CeciStyleAdmin
//
//  Created by Gean Vallejos on 5/16/25.
//

import Foundation
import UserNotifications
import FirebaseMessaging

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate, MessagingDelegate {
    static let shared = NotificationDelegate()

    private override init() {
        super.init()
        Messaging.messaging().delegate = self
    }

    // Captura del token FCM
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else { return }
        print("FCM Token: \(token)")
        // Aquí puedes enviar el token al backend si lo necesitas
    }

    // Maneja notificaciones cuando la app está en foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .banner])
    }

    // Maneja toques en la notificación (cuando el usuario toca la alerta)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
