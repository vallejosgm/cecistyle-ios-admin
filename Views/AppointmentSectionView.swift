//
//  AppointmentSectionView.swift
//  CeciStyleAdmin
//
//  Created by Gean Vallejos on 5/2/25.
//

// AppointmentSectionView.swift

import SwiftUI

struct AppointmentSectionView: View {
    let key: Date
    let appointments: [Appointment]
    @Binding var allAppointments: [Appointment]
    let updateVisibleMonthYear: (Appointment) -> Void

    var body: some View {
        Section {
            Text(monthYearString(for: key))
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.systemBackground))
            ForEach(appointments) { appt in
                if let index = allAppointments.firstIndex(where: { $0.id == appt.id }) {
                    NavigationLink(destination: AppointmentDetailView(appointment: $allAppointments[index])) {
                        AppointmentRow(appt: appt)
                    }
                    .id(appt.id)
                    .onAppear {
                        updateVisibleMonthYear(appt)
                    }
                } else {
                    AppointmentRow(appt: appt)
                        .id(appt.id)
                        .onAppear {
                            updateVisibleMonthYear(appt)
                        }
                }
            }
        }
    }

    private func monthYearString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

