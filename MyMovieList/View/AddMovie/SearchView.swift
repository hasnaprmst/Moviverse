//
//  SearchView.swift
//  MyMovieList
//
//  Created by Hasna Paramesti Ahmad on 05/05/25.
//

import SwiftUI
import SwiftData

// MARK: SearchView with API
struct SearchView: View {
    @StateObject private var viewModel = MovieSearchViewModel()
    @State private var searchText = ""
    @EnvironmentObject var router: Router
    
    var body: some View {
        SearchBarView(placeholder: "Search for a movie", text: $searchText)
            .onChange(of: searchText) { newText in
                viewModel.searchMovies(query: newText)
            }
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal,5)
            .padding(.bottom,-10)
        Spacer()
        VStack{
            if searchText.isEmpty {
                VStack {
                    Image("Search") // nama file gambar di Assets.xcassets
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                        .padding(.top,150)
                    
                    // Deskripsi
                    Text("Looking for a movie?")
                        .font(.body)
                        .padding(.top,20)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Text("Let’s find something to watch!")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                Spacer()
            }
            else{
                ScrollView{
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(viewModel.movies) { movie in
                            Button(action: {
                                router.navigate(to: .detailFromMain(movie: movie))
                            }) {
                                HStack(alignment: .center, spacing: 10) {
                                    // ✅ Poster image
                                    if let posterPath = movie.poster_path,
                                       let url = URL(string: "https://image.tmdb.org/t/p/w200\(posterPath)") {
                                        AsyncImage(url: url) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                                    .frame(width: 70, height: 105)
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 70, height: 105)
                                                    .cornerRadius(8)
                                                    .clipped()
                                            case .failure:
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 70, height: 105)
                                                    .foregroundColor(.gray)
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                    } else {
                                        Image("posterempty")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 70, height: 105)
                                            .foregroundColor(.gray)
                                            .cornerRadius(8)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(movie.title)
                                            .font(.headline)
                                            .lineLimit(1)
                                            .foregroundColor(.white)
                                        if let year = movie.release_date?.prefix(4) {
                                            Text("\(year)")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .frame(maxHeight: .infinity)
                                    
                                    Spacer()
                                    // Chevron Native (panah)
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 10)
                                    
                                }
                                .padding(.top, 4)
                                .padding(.bottom, 8)
                            }
                            Divider()
                        }
                        
                    }
                    
                    .padding()
                    
                }
                
            }
            
        }
        .navigationTitle("Add Movie")
        .navigationBarTitleDisplayMode(.inline)
        
        
    }
}


