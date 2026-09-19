//
//  HourPicker.swift
//  CeciStyleAdmin
//
//  Created by Gean Vallejos on 4/30/25.
//

import SwiftUI

struct HourPicker: View {
    @Binding var selectedHour: String
    var hours: [String]

    var body: some View {
        Picker("Select Hour", selection: $selectedHour) {
            ForEach(hours, id: \.self) { hour in
                Text(hour).tag(hour)
            }
        }
        .pickerStyle(MenuPickerStyle())
    }
}

struct HourRangePicker: View {
    @Binding var hourStart: String
    @Binding var hourEnd: String

    let allHours = [
        "09:00", "09:30", "10:00", "10:30", "11:00", "11:30",
        "12:00", "12:30", "13:00", "13:30", "14:00", "14:30",
        "15:00", "15:30", "16:00", "16:30", "17:00", "17:30",
        "18:00", "18:30"
    ]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Start Hour")
            HourPicker(selectedHour: $hourStart, hours: allHours)

            Text("End Hour")
            HourPicker(selectedHour: $hourEnd, hours: allHours.filter { $0 > hourStart })
        }
    }
}

