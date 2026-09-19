//
//  AppointmentListView.swift
//  CeciStyleAdmin
//
//  Created by Gean Vallejos on 4/26/25.
//

// AppointmentListView.swift

import SwiftUI

struct AppointmentListView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @State private var isLoading = true
    @State private var isRefreshing = false
    @State private var appointments: [Appointment] = []
    @State private var groupedAppointments: [Date: [Appointment]] = [:]
    @State private var scrollTarget: Int?
    @State private var visibleMonthYear: String = ""
    @State private var nowMonthYear = ""
    @State private var showingAddAppointmentView = false

    private let monthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()

    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                VStack(spacing: 0) {
                    if isLoading {
                        VStack {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(1.5)
                            Spacer()
                        }
                        .onAppear {
                            loadAppointments(proxy: proxy)
                        }
                    } else {
                        if groupedAppointments.isEmpty {
                            VStack {
                                Spacer()
                                Text("No appointments available")
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                        } else {
                            List {
                                ForEach(groupedAppointments.keys.sorted(), id: \.self) { key in
                                    AppointmentSectionView(
                                        key: key,
                                        appointments: groupedAppointments[key] ?? [],
                                        allAppointments: $appointments,
                                        updateVisibleMonthYear: updateVisibleMonthYear
                                    )
                                }
                                .padding(.bottom, 5)
                            }
                            .listSectionSeparator(.hidden)
                            .listStyle(.plain)
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(visibleMonthYear.isEmpty ? currentMonthYear() : visibleMonthYear)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            sessionManager.logout()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.blue)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack(spacing: 10) {
                            Button(action: {
                                        isRefreshing = true
                                        refreshAppointments()
                                    }) {
                                Image(systemName: "arrow.clockwise")
                                    .rotationEffect(isRefreshing ? .degrees(360) : .degrees(0))
                                    .animation(isRefreshing ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default, value: isRefreshing)
                                    .foregroundColor(.blue)
                                    .padding(6)
                                    .background(Color(UIColor.systemGray6))
                                    .clipShape(Circle())
                            }

                            Button(action: {
                                showingAddAppointmentView = true
                            }) {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .padding(6)
                                    .background(Color.blue)
                                    .clipShape(Circle())
                            }
                        }
                    }
                }
                .sheet(isPresented: $showingAddAppointmentView) {
                    AppointmentAddView(
                        onAdd: { newAppointment in
                            self.appointments.append(newAppointment)
                            self.groupAppointmentsByMonth()
                        },
                        defaultIdServ: 10
                    )
                }
            }
            .toolbarBackground(Color(UIColor.systemGray5), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .navigationBarBackButtonHidden(true)
    }

    private func loadAppointments(proxy: ScrollViewProxy? = nil) {
        AppointmentService.fetchAppointments { fetched in
            DispatchQueue.main.async {
                self.appointments = fetched ?? []
                self.groupAppointmentsByMonth()
                self.findNearestAppointment()
                self.isLoading = false
                
                // Actualiza el badge con las citas pendientes
                let pendingCount = appointments.filter { $0.isNew == true }.count
                //let pendingCount = 2
                if #available(iOS 17.0, *) {
                    UNUserNotificationCenter.current().setBadgeCount(pendingCount) { error in
                        if let error = error {
                            print("Error setting badge count: \(error.localizedDescription)")
                        }
                    }
                } else {
                    UIApplication.shared.applicationIconBadgeNumber = pendingCount
                }

                if let target = scrollTarget {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation {
                            proxy?.scrollTo(target, anchor: .top)
                        }
                    }
                }
            }
        }
    }

    private func fetchAppointments(proxy: ScrollViewProxy? = nil) {
        AppointmentService.fetchAppointments { fetched in
            DispatchQueue.main.async {
                self.appointments = fetched ?? []
                self.groupAppointmentsByMonth()
                self.findNearestAppointment()
                
                // Actualiza el badge con las citas pendientes
                let pendingCount = appointments.filter { $0.isNew == true }.count
                //let pendingCount = 2
                if #available(iOS 17.0, *) {
                    UNUserNotificationCenter.current().setBadgeCount(pendingCount) { error in
                        if let error = error {
                            print("Error setting badge count: \(error.localizedDescription)")
                        }
                    }
                } else {
                    UIApplication.shared.applicationIconBadgeNumber = pendingCount
                }

                if let target = scrollTarget {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation {
                            proxy?.scrollTo(target, anchor: .top)
                        }
                    }
                }
            }
        }
    }

    private func refreshAppointments() {
        scrollTarget = nil
        fetchAppointments()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {  // asegúrate de resetearlo después
            self.isRefreshing = false
        }
    }

    private func groupAppointmentsByMonth() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        var grouped = [Date: [Appointment]]()

        for appt in appointments {
            if let date = formatter.date(from: appt.date) {
                let components = Calendar.current.dateComponents([.year, .month], from: date)
                if let monthYear = Calendar.current.date(from: components) {
                    grouped[monthYear, default: []].append(appt)
                }
            }
        }

        self.groupedAppointments = grouped
    }

    private func findNearestAppointment() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        for appt in appointments {
            if let date = formatter.date(from: appt.date) {
                let apptDay = calendar.startOfDay(for: date)
                if apptDay >= today {
                    scrollTarget = appt.id
                    break
                }
            }
        }
    }

    private func currentMonthYear() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: Date())
    }

    private func updateVisibleMonthYear(for appointment: Appointment) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: appointment.date) {
            let monthYearFormatter = DateFormatter()
            monthYearFormatter.locale = Locale(identifier: "en_US_POSIX")
            monthYearFormatter.dateFormat = "MMMM yyyy"
            let newMonthYear = monthYearFormatter.string(from: date)

            if newMonthYear != visibleMonthYear {
                visibleMonthYear = newMonthYear
            }
        }
    }
}
