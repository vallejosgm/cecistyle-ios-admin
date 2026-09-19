//
//  LogoService.swift
//  CeciStyleAdmin
//
//  Created by Gean Vallejos on 4/28/25.
//

import Foundation

struct SettingService {
    static func fetchLogo(completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "\(Config.baseURL)/api/logo") else {
            print("URL inválida para logo")
            completion(nil)
            return
        }
        
        let request = TokenInterceptor.authorizedRequest(url: url, method: "GET")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error al obtener logo: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No se recibió data del logo")
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let logoURL = json["logo"] as? String {
                    completion(logoURL)
                } else {
                    completion(nil)
                }
            } catch {
                print("Error parseando logo: \(error.localizedDescription)")
                completion(nil)
            }
        }
        task.resume()
    }
}
