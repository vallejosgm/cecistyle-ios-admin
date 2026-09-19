//
//  AppointmentRow 2.swift
//  CeciStyleAdmin
//
//  Created by Gean Vallejos on 4/27/25.
//


//
//  AppointmentRow.swift
//  CeciStyleAdmin
//
//  Created by Gean Vallejos on 4/27/25.
//

// AppointmentRow.swift

import SwiftUI

struct AppointmentRow: View {
    let appt: Appointment
    
    var isPast: Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: appt.date) {
            return date < Date()
        }
        return false
    }

    var detail: String {
        var text = "\(appt.nameService) \(formattedPhone)"
        if let message = appt.message, !message.isEmpty {
            text += " \(message)"
        }
        return text
    }
    
    var formattedHours: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "h:mm a"
        
        guard
            let start = formatter.date(from: String(appt.hour_start.prefix(5))),
            let end = formatter.date(from: String(appt.hour_end.prefix(5)))
        else {
            return "\(appt.hour_start.prefix(5)) - \(appt.hour_end.prefix(5))"
        }
        
        return "\(outputFormatter.string(from: start)) - \(outputFormatter.string(from: end))"
    }
    
    var formattedPhone: String {
        let phoneString = String(appt.phone)
        guard phoneString.count == 10 else { return phoneString }
        let areaCode = phoneString.prefix(3)
        let middle = phoneString.dropFirst(3).prefix(3)
        let last = phoneString.suffix(4)
        return "(\(areaCode)) \(middle)-\(last)"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("\(appt.Day)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 34, height: 34)
                    .background(isPast ? Color.gray : Color.blue)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text(formattedHours)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    Text(appt.fullName)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                Spacer()
            }
            Text(detail)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isPast ? Color(UIColor.systemGray5) : Color(UIColor.systemBackground))
                .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
        )
        .animation(.easeInOut(duration: 0.3), value: isPast)
    }
}