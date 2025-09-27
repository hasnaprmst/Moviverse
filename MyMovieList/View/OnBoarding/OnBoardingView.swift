//
//  OnBoardingView.swift
//  MyMovieList
//
//  Created by M Riza Levandy on 11/05/25.
//

import SwiftUI

struct OnBoardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State var currentPage = 0
    @Binding var showOnboardingScreen: Bool
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage, content: {
                OnBoardingPage1View(currentPage: $currentPage)
                    .tag(0)
                OnBoardingPage2View(currentPage: $currentPage)
                    .tag(1)
                OnBoardingPage3View(currentPage: $currentPage)
                    .tag(2)
            }).tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                .ignoresSafeArea()
            
            Button {
                withAnimation {
                    if currentPage < 2 {
                        currentPage += 1
                    } else {
                        hasCompletedOnboarding = true
                        showOnboardingScreen = false
                    }
                }
            } label: {
                Text(currentPage < 2 ? "Next" : "Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .init(horizontal: .center, vertical: .center))
                    .background(Color("mainColor"))
                    .cornerRadius(10)
            }.background(RoundedRectangle(cornerRadius: 10).fill(Color("mainColor")))
            .padding()
        }
    }
}


