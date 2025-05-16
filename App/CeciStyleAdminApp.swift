//
//  CeciStyleAdminApp.swift
//  CeciStyleAdmin
//
//  Created by Gean Vallejos on 4/26/25.
//

import SwiftUI

@main
struct CeciStyleAdminApp: App {
    @StateObject var sessionManager = SessionManager()
    
    var body: some Scene {
        WindowGroup {
            CeciStyleRootView()
                .environmentObject(sessionManager)
        }
    }
}
