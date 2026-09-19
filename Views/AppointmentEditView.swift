//
//  AppointmentEditView.swift
//  CeciStyleAdmin
//
//  Created by Gean Vallejos on 4/28/25.
//

import SwiftUI

struct AppointmentEditView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var appointment: Appointment

    @State private var fullName = ""
    @State private var nameService = ""
    @State private var phoneString = ""
    @State private var email = ""
    @State private var date = Date()
    @State private var hourStart = ""
    @State private var hourEnd = ""
    @State private var message = ""
    @State private var services: [Service] = []
    @State private var id_serv: Int
    @State private var isLoading = false
    @State private var sentEmail: Int
    @State private var errorMessage: String?
    
    // ✅ Explicit initializer
    init(appointment: Binding<Appointment>) {
        self._appointment = appointment
        let appt = appointment.wrappedValue
        self._fullName = State(initialValue: appt.fullName)
        self._nameService = State(initialValue: appt.nameService)
        self._phoneString = State(initialValue: String(appt.phone))
        self._email = State(initialValue: appt.email)
        self._hourStart = State(initialValue: String(appt.hour_start.prefix(5)))
        self._hourEnd = State(initialValue: String(appt.hour_end.prefix(5)))
        self._sentEmail = State(initialValue: appt.sentEmail)
        self._message = State(initialValue: appt.message ?? "")
        self._id_serv = State(initialValue: appt.id_serv)

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let parsedDate = formatter.date(from: appt.date) {
            self._date = State(initialValue: parsedDate)
        } else {
            self._date = State(initialValue: Date())
        }
    }
    
    let hourOptions = ["09:00", "09:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:00", "13:30", "14:00",
                       "14:30", "15:00", "15:30", "16:00", "16:30", "17:00", "17:30", "18:00", "18:30", "19:00"]

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Full Name", text: $fullName)
                    Picker("Service", selection: $id_serv) {
                        ForEach(services) { service in
                            Text(service.name).tag(service.id as Int?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    TextField("Phone", text: $phoneString)
                        .keyboardType(.phonePad)
                        .onChange(of: phoneString) {
                            // Permitir solo dígitos
                            phoneString = phoneString.filter { "0123456789".contains($0) }
                            if phoneString.count > 11 {
                                phoneString = String(phoneString.prefix(11))
                            }
                        }
                    TextField("Email", text: $email)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    HStack {
                        Text("Start Hour")
                        Spacer()
                        Picker("", selection: $hourStart) {
                            ForEach(hourOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .labelsHidden()
                    }
                    HStack {
                        Text("End Hour")
                        Spacer()
                        Picker("", selection: $hourEnd) {
                            ForEach(hourOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .labelsHidden()
                    }
                    Text("The email has already been sent. Would you like to resend the email?")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Picker("Title", selection: $sentEmail) {
                        Text("No").tag(1)
                        Text("Yes").tag(0)
                    }
                        .pickerStyle(SegmentedPickerStyle())
                    TextField("Message", text: $message)
                } header: {
                    Text("Edit Appointment")
                }
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                Button("Update Appointment") {
                    updateAppointment()
                }
                .disabled(isLoading)
            }
            .navigationTitle("Edit Appointment")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                loadData()
            }
        }
    }
    
    func loadData() {
        fullName = appointment.fullName
        phoneString = String(appointment.phone)
        email = appointment.email
        hourStart = String(appointment.hour_start.prefix(5))
        hourEnd = String(appointment.hour_end.prefix(5))
        sentEmail = appointment.sentEmail
        message = appointment.message ?? ""
        id_serv = appointment.id_serv
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let parsedDate = formatter.date(from: appointment.date) {
            date = parsedDate
        }
        
        fetchServices()
    }
    
    func updateAppointment() {
        isLoading = true
        errorMessage = nil
        
        guard let phoneInt = Int(phoneString) else {
            errorMessage = "Invalid phone number"
            return
        }
        
        AppointmentService.updateAppointment(
            id: appointment.id,
            fullName: fullName,
            phone: phoneInt,
            email: email,
            date: date,
            hourStart: hourStart,
            hourEnd: hourEnd,
            id_serv: id_serv,
            sentEmail: sentEmail,
            message: message
        ) { updatedAppointment in
            DispatchQueue.main.async {
                isLoading = false
                if let updated = updatedAppointment {
                    self.appointment = updated
                    dismiss()
                } else {
                    self.errorMessage = "Failed to update appointment"
                }
            }
        }
    }
    
    func fetchServices() {
        ServicesService.fetchServices { services in
            DispatchQueue.main.async {
                self.services = services ?? []
            }
        }
    }
}

