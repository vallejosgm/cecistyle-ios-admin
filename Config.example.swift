import Foundation

struct Config {
    static let isProduction = false

    static var baseURL: String {
        return "https://example.com"
    }

    static var loginURL: String {
        return "\(baseURL)/login"
    }

    static var updateAppointmentURL: (Int) -> String {
        return { id in
            "\(baseURL)/appointments/\(id)"
        }
    }
}
