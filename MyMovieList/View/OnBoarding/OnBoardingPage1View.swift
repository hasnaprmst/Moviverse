//
//  OnBoardingPage1View.swift
//  MyMovieList
//
//  Created by M Riza Levandy on 11/05/25.
//

import SwiftUI

struct OnBoardingPage1View: View {
   @Binding var currentPage: Int
    
    var body: some View {
        VStack {
            Image("onBoarding1")
                .resizable()
                .scaledToFit()
                .frame(height: 250)
            
            Text("Welcome to Moviverse")
                .font(.title3)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("All your movie recommendation in one place.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}

#Preview {
    OnBoardingPage1View(currentPage: .constant(0))
}

