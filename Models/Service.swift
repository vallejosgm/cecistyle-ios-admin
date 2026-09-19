//
//  Service.swift
//  CeciStyleAdmin
//
//  Created by Gean Vallejos on 4/29/25.
//

import Foundation

struct Service: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String
    let duration_minutes: Int
    let priority: Int
}
