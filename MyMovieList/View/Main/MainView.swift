//
//  MainView.swift
//  MyMovieList
//
//  Created by Hasna Paramesti Ahmad on 05/05/25.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @State private var showingAddSheet = false
    @State private var isAddingMovie = false
    @State private var showRandomPicker: Bool = false
    @Query var playlists: [Playlist]
    @State private var hasMovies = false // Menyimpan apakah sudah ada film yang ditambahkan
    @EnvironmentObject var router: Router
    
    private var totalMovies: Int {
          playlists.reduce(0) { $0 + $1.movies.count } // Menghitung jumlah film dari setiap playlist
      }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    // Kondisi jika belum ada film yang ditambahkan
                    if playlists.isEmpty {
                        VStack {
                            Image("moviversecool") // nama file gambar di Assets.xcassets
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .cornerRadius(12)
                                .shadow(radius: 5)
                                .padding(.top, 150)
                            
                            // Deskripsi
                            Text("Your WatchList is Empty")
                                .font(.body)
                                .padding(.top, 20)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            Text("Time to Add Your First Movie!")
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            Button(action: { router.navigate(to: .search) })
                            {
                                Text("+ ADD MOVIE")
                                    .frame(maxWidth: 200)
                                    .font(.headline)
                                    .foregroundColor(Color("secondColor"))
                                    .padding()
                                    
                                    .background(Color("mainColor"))
                                    .cornerRadius(10)
                            }
                            .padding(.top, 20)
                        }
                    } else {
                        // Kondisi jika sudah ada film yang ditambahkan
                        ZStack {
                            Image("randomize2")
                            .resizable()
                            .frame(width: 354, height: 205)
                            .cornerRadius(16)
                            
                            Button(action: { showRandomPicker = true })
                            {
                                Text("RANDOMIZE NOW")
                                    .frame(maxWidth: 300)
                                    .font(.headline)
                                    .foregroundColor(totalMovies < 2 ? .black.opacity(0.3) : Color("secondColor"))
                                    .padding()
                                    .background(totalMovies < 2 ? Color.gray : Color("mainColor"))
                                    .cornerRadius(10)
                            }
                            .padding(.top, 140)
                            .disabled(totalMovies < 2)
                          
                        }
                    }
                    
                    // Playlist
                    VStack {
                        Playlist2View() // Asumsi Playlist2View adalah tampilan daftar film yang sudah ditambahkan
                    }
                }
            }
            
            .tint(Color("mainColor"))
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        router.navigate(to: .search)
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationDestination(isPresented: $isAddingMovie) {
                SearchView()
            }
            .sheet(isPresented: $showRandomPicker) {
                RandomPickerView()
                
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .search:
                    SearchView()
                case .detailFromMain(let movie):
                    MovieDetailView(movie: movie)
                case .playlistDetail(let playlist):
                    PlaylistDetailView(playlist: playlist)
                case .searchInPlaylist(let playlist):
                    Search2View(playlist: playlist)
                        .environmentObject(router)
                case .detailFromPlaylist(let movie, let playlist):
                    MovieDetail2View(movie: movie, playlist: playlist)
                
                }
            }
        }
    }
}

#Preview {
    MainView()
}
