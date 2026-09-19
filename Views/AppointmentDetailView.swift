//
//  AppointmentDetailView.swift
//  CeciStyleAdmin
//
//  Created by Gean Vallejos on 4/28/25.
//

import SwiftUI

struct AppointmentDetailView: View {
    @Binding var appointment: Appointment
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Appointment Detail")
                .font(.largeTitle)
                .bold()
            
            Group {
                Text("Name: \(appointment.fullName)")
                Text("Service: \(appointment.nameService)")
                Text("Phone: \(appointment.phone)")
                Text("Email: \(appointment.email)")
                Text("Date: \(formatDate(appointment.date))")
                Text("Hours: \(appointment.hour_start) - \(appointment.hour_end)")
                Text("Message: \(appointment.message ?? "-")")
            }
            .font(.body)
            
            Spacer()
            
            HStack {
                Button("Edit") {
                    showingEditView = true
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("Delete") {
                    showingDeleteAlert = true
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {}
            }
        }
        .alert("Delete Appointment?", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                deleteAppointment()
            }
        }
        .sheet(isPresented: $showingEditView) {
            AppointmentEditView(appointment: $appointment)
        }
    }
    
    func formatPhone(_ phone: Int) -> String {
        let phoneString = String(phone)
        guard phoneString.count == 10 else { return phoneString }
        let area = phoneString.prefix(3)
        let middle = phoneString.dropFirst(3).prefix(3)
        let last = phoneString.suffix(4)
        return "(\(area)) \(middle)-\(last)"
    }

    func deleteAppointment() {
        // Aquí llamas a tu API de eliminar
        AppointmentService.deleteAppointment(id: appointment.id) { success in
            if success {
                DispatchQueue.main.async {
                    dismiss()
                }
            }
        }
    }
    
    func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMMM d, yyyy"
        outputFormatter.locale = Locale(identifier: "en_US")

        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            return dateString // fallback si no puede parsear
        }
    }
}
