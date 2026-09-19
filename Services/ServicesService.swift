//
//  ServicesService.swift
//  CeciStyleAdmin
//
//  Created by Gean Vallejos on 4/29/25.
//

import Foundation

struct ServicesService {
    static func fetchServices(completion: @escaping ([Service]?) -> Void) {
        guard let url = URL(string: "\(Config.baseURL)/api/services") else {
            completion(nil)
            return
        }
        
        let request = TokenInterceptor.authorizedRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let data = data else {
                completion(nil)
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode([String: [Service]].self, from: data)
                completion(decoded["services"])
            } catch {
                print("Error parseando servicios: \(error.localizedDescription)")
                completion(nil)
            }
        }
        task.resume()
    }
}

