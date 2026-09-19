//
//  TokenInterceptor.swift
//  CeciStyleAdmin
//
//  Created by Gean Vallejos on 4/28/25.
//

import Foundation

struct TokenInterceptor {
    static func authorizedRequest(
        url: URL,
        method: String = "GET",
        body: Data? = nil
    ) -> URLRequest {

        var request = URLRequest(url: url)

        request.timeoutInterval = 60
        request.httpMethod = method
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        if let token = KeychainManager.getAuthToken(),
           !token.isEmpty {
            request.setValue(
                "Bearer \(token)",
                forHTTPHeaderField: "Authorization"
            )
        }

        request.httpBody = body

        return request
    }
}
