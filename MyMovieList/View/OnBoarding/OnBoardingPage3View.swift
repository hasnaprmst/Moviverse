//
//  OnBoardingPage3View.swift
//  MyMovieList
//
//  Created by M Riza Levandy on 11/05/25.
//

import SwiftUI

struct OnBoardingPage3View: View {
   @Binding var currentPage: Int
    
    var body: some View {
        VStack {
            Image("onBoarding3")
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .padding(.bottom,-10)
             
            
            Text("Filter & Randomize Your Picks")
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.top,30)
                
            
            Text("Filter by mood, era, duration, or let moviverse choose for you.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.bottom,50)
        }
    }
}

#Preview {
    OnBoardingPage3View(currentPage: .constant(0))
}
