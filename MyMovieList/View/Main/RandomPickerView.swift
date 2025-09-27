//
//  RandomPickerView.swift
//  MyMovieList
//
//  Created by Hasna Paramesti Ahmad on 06/05/25.
//

import SwiftUI
import SwiftData

struct RandomPickerView: View {
    @Environment(\.dismiss) var dismiss
    @Query private var allMovies: [Movie] // Ambil semua movie dari semua playlist

    @State private var selectedMovie: Movie? = nil
    @State private var shownMovies: Set<Movie> = []

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                VStack(spacing: 12) {
                    if let movie = selectedMovie {
                        Text(movie.genreMessage)
                            .font(.title)
                            .fontWeight(/*@START_MENU_TOKEN@*/.semibold/*@END_MENU_TOKEN@*/)
                            .frame(maxWidth: .infinity, alignment: .center) // Center the text horizontally
                            .multilineTextAlignment(.center) // Center the text content
                            .fixedSize(horizontal: false, vertical: true) // Prevent layout change on text wrap
                            .frame(height: 50) // Set a fixed height for the genre message text to avoid layout shift
                            .padding(.bottom, 10)
                            .padding(.top,40)
                        
                        if let posterPath = movie.posterPath,
                           let url = URL(string: "https://image.tmdb.org/t/p/w300\(posterPath)") {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 400)
                                    .cornerRadius(12)
                            } placeholder: {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 250)
                                    .cornerRadius(12)
                                
                            }
                        }
                         
                    } else {
                        Text("No movie selected yet")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center) // Center the text when no movie is selected
                            .frame(height: 600) // Fixed height for the fallback text
                    }

                    Spacer()
                    Button("RANDOM PICKER") {
                        pickNextMovie()
                    }
                    .font(.headline)
                    .foregroundColor(Color("secondColor"))
                    .frame(maxWidth: 250)
                    .padding()
                    .background(Color("mainColor")) // Ensure this color is in Assets.xcassets
                    .cornerRadius(12)
                    
                    Image("randomize1") // nama file gambar di Assets.xcassets
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .padding(.leading,-200)
                        .padding(.top,10)
                
                    
                }
                .padding(.horizontal) // Adds safe horizontal padding to prevent items from touching edges
                .padding(.top,30) // Adds safe top padding for proper spacing
//                Button("Tutup") {
//                    dismiss()
//                }
//                .foregroundColor(.red)
//                .padding(.top, 8)
            }
            .navigationTitle("🎲 Random Picker")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
            .onAppear {
                // Pilih film pertama kali saat view muncul
                pickNextMovie()
            }
        }
        
    }

    func pickNextMovie() {
        let remaining = allMovies.filter { !shownMovies.contains($0) }

        if let next = remaining.randomElement() {
            selectedMovie = next
            shownMovies.insert(next)
        } else {
            // Semua film sudah ditampilkan, mulai ulang
            shownMovies.removeAll()
            if let next = allMovies.randomElement() {
                selectedMovie = next
                shownMovies.insert(next)
            }
        }
    }
}

#Preview {
    RandomPickerView()
}
