//
//  SplashScreen.swift
//  CeciStyleAdmin
//
//  Created by Gean Vallejos on 4/28/25.
//

import SwiftUI

struct SplashScreen: View {
    @State private var logoURL: String?
    @State private var logoScale: CGFloat = 0.6
    @State private var logoOpacity: Double = 0.0

    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)

            if let logoURL = logoURL, let url = URL(string: logoURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(logoScale)
                            .opacity(logoOpacity)
                            .frame(width: 220, height: 220)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
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
            withAnimation(.easeIn(duration: 1.2)) {
                self.logoScale = 1.0
                self.logoOpacity = 1.0
            }

            SettingService.fetchLogo { fetchedLogoURL in
                DispatchQueue.main.async {
                    self.logoURL = fetchedLogoURL
                }
            }
        }
    }
}
