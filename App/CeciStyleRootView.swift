//
//  CeciStyleRootView.swift
//  CeciStyleAdmin
//
//  Created by Gean Vallejos on 4/28/25.
//

import SwiftUI

struct CeciStyleRootView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @State private var isShowingSplash = true

    var body: some View {
        Group {
            if isShowingSplash {
                SplashScreen()
                    .environmentObject(sessionManager)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation {
                                self.isShowingSplash = false
                            }
                        }
                    }
            } else if sessionManager.isLoggedIn {
                AppointmentListView()
                    .environmentObject(sessionManager)
                    .onAppear {
                                if #available(iOS 17.0, *) {
                                    UNUserNotificationCenter.current().setBadgeCount(0) { error in
                                        if let error = error {
                                            print("Error resetting badge count: \(error)")
                                        }
                                    }
                                } else {
                                    UIApplication.shared.applicationIconBadgeNumber = 0
                                }
                            }
            } else if sessionManager.needsAuthentication && !sessionManager.forceManualLogin {
                FaceIDLoginView(isLoggedIn: $sessionManager.isLoggedIn, forceManualLogin: $sessionManager.forceManualLogin)
                    .environmentObject(sessionManager)
            } else {
                LoginView()
                    .environmentObject(sessionManager)
            }
        }
    }
}
