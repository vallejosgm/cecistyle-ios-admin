//
//  CeciStyleAdminTests.swift
//  CeciStyleAdminTests
//
//  Created by Gean Vallejos on 4/26/25.
//

import Foundation
import Testing

@testable import CeciStyleAdmin

struct CeciStyleAdminTests {

    @Test
    func appointmentDecodesFromJSON() throws {
        let json = """
        {
            "id": 101,
            "date": "2026-09-19",
            "hour_start": "10:00",
            "hour_end": "10:30",
            "email": "customer@example.com",
            "phone": "8015550100",
            "fullName": "Test Customer",
            "message": "Test appointment",
            "id_serv": 10,
            "nameService": "Consultation",
            "Description": "Initial consultation",
            "Day": 19,
            "Month": 9,
            "sentEmail": 1,
            "isNew": true
        }
        """

        let data = try #require(json.data(using: .utf8))
        let appointment = try JSONDecoder().decode(
            Appointment.self,
            from: data
        )

        #expect(appointment.id == 101)
        #expect(appointment.date == "2026-09-19")
        #expect(appointment.hour_start == "10:00")
        #expect(appointment.hour_end == "10:30")
        #expect(appointment.email == "customer@example.com")
        #expect(appointment.phone == "8015550100")
        #expect(appointment.fullName == "Test Customer")
        #expect(appointment.message == "Test appointment")
        #expect(appointment.id_serv == 10)
        #expect(appointment.nameService == "Consultation")
        #expect(appointment.sentEmail == 1)
        #expect(appointment.isNew == true)
    }

    @Test
    func appointmentDecodesWithNullOptionalValues() throws {
        let json = """
        {
            "id": 102,
            "date": "2026-09-20",
            "hour_start": "14:00",
            "hour_end": "14:30",
            "email": "customer@example.com",
            "phone": "8015550101",
            "fullName": "Test Customer",
            "message": null,
            "id_serv": 10,
            "nameService": "Consultation",
            "Description": "Initial consultation",
            "Day": 20,
            "Month": 9,
            "sentEmail": 0,
            "isNew": null
        }
        """

        let data = try #require(json.data(using: .utf8))
        let appointment = try JSONDecoder().decode(
            Appointment.self,
            from: data
        )

        #expect(appointment.message == nil)
        #expect(appointment.isNew == nil)
    }

    @Test
    func appointmentsWithSameValuesAreEqual() {
        let first = makeAppointment()
        let second = makeAppointment()

        #expect(first == second)
    }

    private func makeAppointment() -> Appointment {
        Appointment(
            id: 103,
            date: "2026-09-21",
            hour_start: "09:00",
            hour_end: "09:30",
            email: "customer@example.com",
            phone: "8015550102",
            fullName: "Test Customer",
            message: nil,
            id_serv: 10,
            nameService: "Consultation",
            Description: "Initial consultation",
            Day: 21,
            Month: 9,
            sentEmail: 0,
            isNew: false
        )
    }
}
