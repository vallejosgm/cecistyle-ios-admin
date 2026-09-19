//
//  CeciStyleAdminApp.swift
//  CeciStyleAdmin
//
//  Created by Gean Vallejos on 4/26/25.
//

import SwiftUI
import UserNotifications
import FirebaseCore

@main
struct CeciStyleAdminApp: App {
    @StateObject var sessionManager = SessionManager()
    
    init() {
        FirebaseApp.configure()

        // Delegado para notificaciones y captura de token
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            CeciStyleRootView()
                .environmentObject(sessionManager)
        }
    }
}
