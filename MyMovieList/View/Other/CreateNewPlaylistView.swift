////
////  CreateNewPlaylistView.swift
////  MyMovieList
////
////  Created by Hasna Paramesti Ahmad on 07/05/25.
////
//
//import SwiftUI
//import SwiftData
//
//struct CreateNewPlaylistView: View {
//    @Environment(\.dismiss) var dismiss
//    @Environment(\.modelContext) var context
//    @Query var playlists: [Playlist]
//    
//    let tmdbMovie: TMDBMovie
//    //    @Binding var path: NavigationPath
//    
//    @State private var newPlaylistTitle = ""
//    @State private var newPlaylistNotes = ""
//    @State private var showAlert = false
//    @State private var addedToPlaylistName = ""
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                Form {
//                    Section(header: Text("Judul Playlist")) {
//                        TextField("Judul", text: $newPlaylistTitle)
//                            .onChange(of: newPlaylistTitle) { newValue in
//                                        if newValue.count > 30 {
//                                            newPlaylistTitle = String(newValue.prefix(30))
//                                        }
//                                    }
//                    }
//                    Section(header: Text("Deskripsi")) {
//                        TextField("Deskripsi (optional)", text: $newPlaylistNotes)
//                            .onChange(of: newPlaylistNotes) { newValue in
//                                        if newValue.count > 100 {
//                                            newPlaylistNotes = String(newValue.prefix(100))
//                                        }
//                                    }
//                    }
//                }
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Simpan") {
//                        let genres = tmdbMovie.genre_ids.compactMap {
//                            genreDictionary[$0] }
//                        
//                        let newPlaylist = Playlist(title: newPlaylistTitle, notes: newPlaylistNotes.isEmpty ? nil : newPlaylistNotes
//                        )
//                        context.insert(newPlaylist)
//                        
//                        let newMovie = Movie(
//                            title: tmdbMovie.title,
//                            overview: tmdbMovie.overview,
//                            releaseDate: tmdbMovie.release_date,
//                            genres: genres,
//                            posterPath: tmdbMovie.poster_path,
//                            backdropPath: tmdbMovie.backdrop_path,
//                            tmdbID: tmdbMovie.id,
//                            voteAverage: tmdbMovie.vote_average
//                        )
//                        
//                        context.insert(newMovie)
//                        newPlaylist.movies.append(newMovie)
//                        
//                        do {
//                            try context.save()
//                            addedToPlaylistName = newPlaylist.title
//                            showAlert = true
//                        } catch {
//                            print("❌ Gagal menyimpan context: \(error.localizedDescription)")
//                        }
//                        
//                    }
//                }
//            }
//            .navigationTitle("Buat Playlist Baru")
//            .alert("🎉 Film berhasil ditambahkan!", isPresented: $showAlert) {
//                Button("OK") {
//                    dismiss() // tutup sheet
//                }
//            } message: {
//                Text("\"\(tmdbMovie.title)\" telah ditambahkan ke playlist \"\(addedToPlaylistName)\".")
//            }
//        }
//        
//    }
//}
//
//#Preview {
//    // Contoh dummy TMDBMovie
//    let sampleMovie = TMDBMovie(
//        id: 123,
//        title: "Contoh Film",
//        overview: "Ini adalah deskripsi film contoh.",
//        release_date: "2023-10-01",
//        genre_ids: [28, 35],
//        poster_path: "/samplePoster.jpg",
//        backdrop_path: "/sampleBackdrop.jpg",
//        vote_average: 8.0
//    )
//    
//    return CreateNewPlaylistView(tmdbMovie: sampleMovie)
//        .modelContainer(for: [Playlist.self, Movie.self], inMemory: true) // in-memory SwiftData for preview
//}
