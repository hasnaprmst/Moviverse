//
//  MyMovieListApp.swift
//  MyMovieList
//
//  Created by Hasna Paramesti Ahmad on 05/05/25.
//
import SwiftUI
import SwiftData

@main
struct MyMovieListApp: App {
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false  // Menyimpan status onboarding
    @State private var showSplash = true // Status untuk Splash Screen
    @State private var showOnboardingScreen = false // Status untuk Onboarding
    @StateObject private var router = Router() // Untuk router
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashScreenView(showSplash: $showSplash, showOnboardingScreen: $showOnboardingScreen, hasCompletedOnboarding: $hasCompletedOnboarding) // Menampilkan Splash Screen
                } else if showOnboardingScreen {
                    OnBoardingView(showOnboardingScreen: $showOnboardingScreen) // Menampilkan Onboarding
                        .preferredColorScheme(.dark)
                } else {
                    MainView() // Menampilkan MainView setelah Onboarding
                        .preferredColorScheme(.dark)
                        .environmentObject(router)
                }
            }
            
        }
        .modelContainer(for: [Movie.self, Playlist.self])
    }
}
