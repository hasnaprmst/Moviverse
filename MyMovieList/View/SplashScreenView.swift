//
//  SplashScreenView.swift
//  MyMovieList
//
//  Created by M Riza Levandy on 11/05/25.
//

import SwiftUI

struct SplashScreenView: View {
    @Binding var showSplash: Bool
    @Binding var showOnboardingScreen: Bool
    @Binding var hasCompletedOnboarding: Bool
    
    var body: some View {
        ZStack {
            Image("splashScreen")   
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .onAppear {
            // Tampilkan splash screen selama 2 detik, kemudian lanjut ke Onboarding
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    showSplash = false // Sembunyikan splash screen
                    if !hasCompletedOnboarding {
                        showOnboardingScreen = true // Tampilkan onboarding jika belum selesai
                    } else {
                        showOnboardingScreen = false // Langsung ke MainView jika sudah selesai onboarding
                    }
                }
            }
        }
    }
}
