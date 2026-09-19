//
//  LoginView.swift
//  CeciStyleAdmin
//
//  Created by Gean Vallejos on 4/28/25.
//

// LoginView.swift

import SwiftUI

struct LoginView: View {
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var isLoggedIn = false
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                LogoView(width: 120, height: 120)
                    .padding()
                Text("CeciStyle Admin")
                    .font(.largeTitle)
                    .bold()
                
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                if isLoading {
                    ProgressView()
                        .padding()
                }
                
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                Button(action: login) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(isLoading)
                
                Spacer()
            }
            .padding()
            //Nueva forma de navegar al AppointmentListView
            .navigationDestination(isPresented: $isLoggedIn) {
                AppointmentListView()
            }
        }
    }
    
    func login() {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "\(Config.baseURL)/api/loginbyMobile") else {
            self.errorMessage = "URL inválida"
            self.isLoading = false
            return
        }
        
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            self.errorMessage = "Error en datos de login"
            self.isLoading = false
            return
        }
        
        KeychainManager.deleteAuthToken()
        
        let request = TokenInterceptor.authorizedRequest(url: url, method: "POST", body: jsonData)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Error de red: \(error.localizedDescription)"
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No se recibió respuesta"
                }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let token = json["token"] as? String {
                    if KeychainManager.saveAuthToken(token) {
                        DispatchQueue.main.async {
                            self.isLoggedIn = true
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = "Unable to securely save authentication."
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Credenciales incorrectas o respuesta inválida"
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error procesando respuesta"
                }
            }
        }.resume()
    }
}
