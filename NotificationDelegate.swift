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

    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        guard fcmToken != nil else { return }

    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .banner])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
