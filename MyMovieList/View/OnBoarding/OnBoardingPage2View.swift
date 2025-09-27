//
//  OnBoardingPage2View.swift
//  MyMovieList
//
//  Created by M Riza Levandy on 11/05/25.
//

import SwiftUI

struct OnBoardingPage2View: View {
   @Binding var currentPage: Int
    
    var body: some View {
        VStack {
            Image("onBoarding2")
                .resizable()
                .scaledToFit()
                .frame(height: 250)
                .padding(.top, 40)
            
            Text("Make Your Own Playlist")
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("No more app-hopping. Collect your movie recommendations and create playlists that fit your vibe.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}

#Preview {
    OnBoardingPage2View(currentPage: .constant(0))
}
