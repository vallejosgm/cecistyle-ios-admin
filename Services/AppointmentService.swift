//
//  AppointmentService.swift
//  CeciStyleAdmin
//
//  Created by Gean Vallejos on 4/26/25.
//

import Foundation

struct AppointmentService {

    static func fetchAppointments(completion: @escaping ([Appointment]?) -> Void) {
        guard let url = URL(string: "\(Config.baseURL)/api/appointments/mobile-getApptByDates") else {
            print("URL inválida")
            completion(nil)
            return
        }

        // 🗓️ Generar meses y años como tu JavaScript
        let now = Date()
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/Denver")!

        var months = Array(repeating: 0, count: 12)
        var years = Array(repeating: 0, count: 12)

        // Posición central
        months[6] = calendar.component(.month, from: now)
        years[6] = calendar.component(.year, from: now)

        // Ir hacia atrás
        var tempDate = now
        for i in (0..<6).reversed() {
            tempDate = calendar.date(byAdding: .month, value: -1, to: tempDate)!
            months[i] = calendar.component(.month, from: tempDate)
            years[i] = calendar.component(.year, from: tempDate)
        }

        // Ir hacia adelante
        tempDate = now
        for i in 7..<12 {
            tempDate = calendar.date(byAdding: .month, value: 1, to: tempDate)!
            months[i] = calendar.component(.month, from: tempDate)
            years[i] = calendar.component(.year, from: tempDate)
        }

        // Armar JSON
        let body: [String: Any] = [
            "a_months": months,
            "a_years": years
        ]

        // Convertir body a JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            print("Error serializando JSON")
            completion(nil)
            return
        }

        var request = TokenInterceptor.authorizedRequest(url: url, method: "POST", body: jsonData)
            request.setValue("application/json", forHTTPHeaderField: "Accept")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error de red: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No se recibió data")
                completion(nil)
                return
            }

            //if let jsonString = String(data: data, encoding: .utf8) {
            //    print("JSON recibido:\n\(jsonString)")
            //}

            do {
                let decoded = try JSONDecoder().decode([Appointment].self, from: data)
                completion(decoded)
            } catch {
                print("Error parseando JSON: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
    
    static func addAppointment(
        fullName: String,
        phone: Int,
        email: String,
        date: Date,
        hourStart: String,
        hourEnd: String,
        id_serv: Int,
        sentEmail: Int,
        message: String?,
        
        completion: @escaping (Appointment?) -> Void) {
            guard let url = URL(string: "\(Config.baseURL)/api/mobile/appointments/createbyMobile") else {
                completion(nil)
                return
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            let trimmedHourStart = String(hourStart.prefix(5))
            let trimmedHourEnd = String(hourEnd.prefix(5))

            let body: [String: Any] = [
                "fullName": fullName,
                "phone": phone,
                "email": email,
                "date": formatter.string(from: date),
                "hour_start": trimmedHourStart,
                "hour_end": trimmedHourEnd,
                "id_serv": id_serv,
                "sentEmail": sentEmail,
                "message": message ?? ""
            ]
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
                completion(nil)
                return
            }
            
            print(body)
            print(url)
            
            var request = TokenInterceptor.authorizedRequest(url: url, method: "POST", body: jsonData)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let _ = error {
                    print("Error adding appointment: \(String(describing: error?.localizedDescription))")
                    completion(nil)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode),
                      let data = data else {
                        if let data = data, let errorString = String(data: data, encoding: .utf8) {
                            print("Server error: \(errorString)")
                        }
                    completion(nil)
                    return
                }
                
                do {
                    let decoded = try JSONDecoder().decode(UpdateAppointmentResponse.self, from: data)
                    //print(data)
                    completion(decoded.appointment)
                } catch {
                    print("Failed to decode added appointment: \(error)")
                    completion(nil)
                }
            }
            task.resume()
    }
    
    static func deleteAppointment(
        id: Int,
        completion: @escaping (Bool) -> Void
    ) {
        guard let url = URL(string: "\(Config.baseURL)/api/appointments/delete/\(id)") else {
            print("❌ URL inválida")
            completion(false)
            return
        }
        
        let request = TokenInterceptor.authorizedRequest(url: url, method: "DELETE")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Error al eliminar: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Respuesta no válida")
                completion(false)
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                print("✅ Eliminación exitosa, status: \(httpResponse.statusCode)")
                completion(true)
            } else {
                if let data = data, let errorString = String(data: data, encoding: .utf8) {
                    print("❌ Error del servidor: \(errorString)")
                }
                completion(false)
            }
        }
        task.resume()
    }


    static func updateAppointment(
        id: Int,
        fullName: String,
        phone: Int,
        email: String,
        date: Date,
        hourStart: String,
        hourEnd: String,
        id_serv: Int,
        sentEmail: Int,
        message: String?,
        completion: @escaping (Appointment?) -> Void
                )
    {
        guard let url = URL(string: "\(Config.baseURL)/api/mobile/appointments/updatebyMobile/\(id)") else {
            completion(nil)
            return
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let trimmedHourStart = String(hourStart.prefix(5))
        let trimmedHourEnd = String(hourEnd.prefix(5))

        let body: [String: Any] = [
            "_method": "PUT",
            "fullName": fullName,
            "phone": phone,
            "email": email,
            "date": formatter.string(from: date),
            "hour_start": trimmedHourStart,
            "hour_end": trimmedHourEnd,
            "id_serv": String(id_serv),
            "sentEmail": Int(sentEmail),
            "message": message ?? ""
        ]
    
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(nil)
            return
        }
    
        var request = TokenInterceptor.authorizedRequest(url: url, method: "POST", body: jsonData)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
    
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error updating appointment: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                if let data = data, let errorString = String(data: data, encoding: .utf8) {
                    print("Server error: \(errorString)")
                }
                completion(nil)
                return
            }
        
            do {
                let decoded = try JSONDecoder().decode(UpdateAppointmentResponse.self, from: data)
                completion(decoded.appointment)
            } catch {
                print("Failed to decode updated appointment: \(error)")
                completion(nil)
            }

        }
        task.resume()
    }
    
    struct UpdateAppointmentResponse: Codable {
        let success: Bool
        let appointment: Appointment
    }
}
