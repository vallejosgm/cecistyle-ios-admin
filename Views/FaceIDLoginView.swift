//
//  FaceIDLoginView.swift
//  CeciStyleAdmin
//
//  Created by Gean Vallejos on 4/28/25.
//

import SwiftUI
import LocalAuthentication

struct FaceIDLoginView: View {
    @Binding var isLoggedIn: Bool
    @Binding var forceManualLogin: Bool
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            LogoView(width: 120, height: 120)
                .padding()
            
            Text("Welcome to CeciStyle")
                .font(.largeTitle)
                .bold()
                .padding()
            
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Button(action: authenticate) {
                Image(systemName: "faceid")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .padding()
            }
            
            Button("Login manually") {
                forceManualLogin = true
            }
            .padding()
        }
        .onAppear {
            authenticate()
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        // Usar FaceID, TouchID, o passcode
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Authenticate to securely access CeciStyle Admin"
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.isLoggedIn = true
                    } else {
                        self.errorMessage = "Authentication failed. Please try again or use manual login."
                        self.forceManualLogin = true
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.errorMessage = "Face ID / Touch ID or passcode is not available on this device."
                self.forceManualLogin = true
            }
        }
    }
}
