//
//  AppointmentAddView.swift
//  CeciStyleAdmin
//
//  Created by Gean Vallejos on 4/28/25.
//

import SwiftUI

struct AppointmentAddView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var fullName = ""
    @State private var phoneString = ""
    @State private var email = ""
    @State private var date = Date()
    @State private var hourStart = "09:00"
    @State private var hourEnd = "09:30"
    @State private var nameService = "Admin"
    @State private var message = ""
    @State private var id_serv: Int
    @State private var isLoading = false
    @State private var sentEmail = false
    @State private var errorMessage: String?
    @State private var services: [Service] = []
    
    var onAdd: (Appointment) -> Void
    
    init(onAdd: @escaping (Appointment) -> Void, defaultIdServ: Int = 0) {
        self._id_serv = State(initialValue: defaultIdServ)
        self.onAdd = onAdd
    }

    
    let hourOptions = ["09:00", "09:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:00", "13:30", "14:00",
                       "14:30", "15:00", "15:30", "16:00", "16:30", "17:00", "17:30", "18:00", "18:30", "19:00"]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Appointment Info")) {
                    TextField("Full Name", text: $fullName)
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
                    TextField("Email", text: $email)
                    TextField("Phone", text: $phoneString)
                        .keyboardType(.phonePad)
                        .onChange(of: phoneString) {
                            // Permitir solo dígitos
                            phoneString = phoneString.filter { "0123456789".contains($0) }
                            if phoneString.count > 11 {
                                phoneString = String(phoneString.prefix(11))
                            }
                        }
                    Picker("Service", selection: $id_serv) {
                        ForEach(services) { service in
                            Text(service.name).tag(service.id as Int?)
                        }
                    }
                    Text("Send email?")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Picker("Title", selection: $sentEmail) {
                        Text("No").tag(false)
                        Text("Yes").tag(true)
                    }
                        .pickerStyle(SegmentedPickerStyle())
                    TextField("Message", text: $message)
                }
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                Button("Save Appointment") {
                    saveAppointment()
                }
                .disabled(isLoading)
            }
            .navigationTitle("New Appointment")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                fetchServices()
            }
        }
    }
    
    func saveAppointment() {
        errorMessage = nil

        let trimmedPhone = phoneString.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedPhone.isEmpty,
              trimmedPhone.allSatisfy({ $0.isNumber }) else {
            errorMessage = "Invalid phone number"
            return
        }

        isLoading = true

        let sentEmailValue = sentEmail ? 0 : 1

        AppointmentService.addAppointment(
            fullName: fullName,
            phone: trimmedPhone,
            email: email,
            date: date,
            hourStart: hourStart,
            hourEnd: hourEnd,
            id_serv: id_serv,
            sentEmail: sentEmailValue,
            message: message
        ) {
            newAppointment in
                DispatchQueue.main.async {
                    isLoading = false
                    if let added = newAppointment {
                        onAdd(added)
                        dismiss()
                    } else {
                        errorMessage = "Failed to add appointment"
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

