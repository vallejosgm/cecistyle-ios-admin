//
//  SessionManager.swift
//  CeciStyleAdmin
//
//  Created by Gean Vallejos on 4/28/25.
//

import Foundation
import LocalAuthentication
import SwiftUI

class SessionManager: ObservableObject {
    @Published var isLoggedIn = false
    @Published var needsAuthentication = false
    @Published var forceManualLogin = false

    init() {
        if let token = KeychainManager.getAuthToken(), !token.isEmpty {
            needsAuthentication = true
        }
    }

    func login(with token: String) {
        guard KeychainManager.saveAuthToken(token) else {
            return
        }

        isLoggedIn = true
        needsAuthentication = false
        forceManualLogin = false
    }

    func logout() {
        KeychainManager.deleteAuthToken()

        isLoggedIn = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.isLoggedIn = false
        }

        needsAuthentication = false
        forceManualLogin = false
    }

    func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error
        ) {
            let reason = "Authenticate to access CeciStyle Admin"

            context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason
            ) { success, _ in
                DispatchQueue.main.async {
                    if success {
                        self.isLoggedIn = true
                        self.needsAuthentication = false
                    } else {
                        self.forceManualLogin = true
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.forceManualLogin = true
            }
        }
    }
}