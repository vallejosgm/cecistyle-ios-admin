//
//  Appointment.swift
//  CeciStyleAdmin
//
//  Created by Gean Vallejos on 4/26/25.
//

import Foundation

struct Appointment: Codable, Identifiable, Equatable {
    let id: Int
    let date: String
    let hour_start: String
    let hour_end: String
    let email: String
    let phone: String  // <- cambiado a String por seguridad
    let fullName: String
    let message: String?
    let id_serv: Int
    let nameService: String
    let Description: String
    let Day: Int
    let Month: Int
    let sentEmail: Int
    
    let isNew: Bool?
}
