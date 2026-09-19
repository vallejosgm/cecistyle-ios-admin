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
        if let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty {
            needsAuthentication = true
        }
    }
    
    func login(with token: String) {
        UserDefaults.standard.set(token, forKey: "authToken")
        isLoggedIn = true
        needsAuthentication = false
        forceManualLogin = false
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "authToken")
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
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to access CeciStyle Admin"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.isLoggedIn = true
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
