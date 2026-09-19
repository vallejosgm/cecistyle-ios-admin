//
//  LogoView.swift
//  CeciStyleAdmin
//
//  Created by Gean Vallejos on 4/28/25.
//

import SwiftUI

struct LogoView: View {
    @State private var logoURL: String?
    var width: CGFloat = 200
    var height: CGFloat = 200
    
    var body: some View {
        VStack {
            if let logoURL = logoURL, let url = URL(string: logoURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: width, height: height)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: width, height: height)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                ProgressView()
            }
        }
        .onAppear {
            SettingService.fetchLogo { fetchedLogoURL in
                DispatchQueue.main.async {
                    self.logoURL = fetchedLogoURL
                }
            }
        }
    }
}
