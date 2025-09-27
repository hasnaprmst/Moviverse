//
//  CreateNewPlaylistView 2.swift
//  MyMovieList
//
//  Created by Hasna Paramesti Ahmad on 08/05/25.
//

import SwiftUI
import SwiftData

struct CreateNewPlaylist2View: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @Query var playlists: [Playlist]
    
    let tmdbMovie: TMDBMovie
    
    @State private var newPlaylistTitle = ""
    @State private var newPlaylistNotes = ""
    @State private var showAlert = false
    @State private var addedToPlaylistName = ""
    @EnvironmentObject var router: Router

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Form-style inputs
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Title")
                            .font(.headline)
                        TextField("Enter playlist title", text: $newPlaylistTitle)
                            .onChange(of: newPlaylistTitle) { newValue in
                                       if newValue.count > 30 { // Set the character limit here
                                           newPlaylistTitle = String(newValue.prefix(30)) // Limit to 30 characters
                                       }
                                   }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
//                        if !newPlaylistTitle.isEmpty {
//                            Button(action: {
//                                newPlaylistTitle = ""
//                            }) {
//                                Image(systemName: "xmark.circle.fill")
//                                    .foregroundColor(.gray)
//                            }
//                        }
                    }
                    // Notes input
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Description")
                            .font(.headline)
                        TextField("Enter description (optional)", text: $newPlaylistNotes, axis: .vertical)
                                .onChange(of: newPlaylistNotes) { newValue in
                                    if newValue.count > 70 { // Set the character limit here
                                        newPlaylistNotes = String(newValue.prefix(70)) // Limit to 100 characters
                                    }
                                }
                                .lineLimit(3...6)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        
                    }
                }
                .padding(.horizontal)

                Spacer()

                // Save button
                Button(action: {
                    createPlaylist() // Toggle status for expansion
                }) {
                    Text("SAVE")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(newPlaylistTitle.isEmpty ? .gray : Color("secondColor"))
                        .frame(maxWidth: .infinity) // Make button span the full width
                        .padding() // Ensure padding is part of the button area
                        .background(newPlaylistTitle.isEmpty ? Color.gray.opacity(0.3) : Color("mainColor"))
                        .cornerRadius(10)
                        .disabled(newPlaylistTitle.isEmpty)
                }
                .padding()
                
            }
            .padding(4)
            .navigationTitle("Create New Playlist")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("🎉 Movie added!", isPresented: $showAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("\"\(tmdbMovie.title)\" has been added to \"\(addedToPlaylistName)\".")
            }
        }
    }

    private func createPlaylist() {
        let genres = tmdbMovie.genre_ids.compactMap { genreDictionary[$0] }

        let newPlaylist = Playlist(
            title: newPlaylistTitle,
            notes: newPlaylistNotes.isEmpty ? nil : newPlaylistNotes
        )
        context.insert(newPlaylist)

        let newMovie = Movie(
            title: tmdbMovie.title,
            overview: tmdbMovie.overview,
            releaseDate: tmdbMovie.release_date,
            genres: genres,
            posterPath: tmdbMovie.poster_path,
            backdropPath: tmdbMovie.backdrop_path,
            tmdbID: tmdbMovie.id,
            voteAverage: tmdbMovie.vote_average
        )

        context.insert(newMovie)

        // Optional: Add to playlist's movie list explicitly
        newPlaylist.movies.append(newMovie)

        do {
            try context.save()
            addedToPlaylistName = newPlaylist.title
            router.path.removeAll()
//            showAlert = true
//            dismiss()
        } catch {
            print("❌ Failed to save context: \(error.localizedDescription)")
        }
    }
}

#Preview {
    // Contoh dummy TMDBMovie
    let sampleMovie = TMDBMovie(
        id: 123,
        title: "Contoh Film",
        overview: "Ini adalah deskripsi film contoh.",
        release_date: "2023-10-01",
        genre_ids: [28, 35],
        poster_path: "/samplePoster.jpg",
        backdrop_path: "/sampleBackdrop.jpg",
        vote_average: 8.0
        
        
    )
    
    return CreateNewPlaylist2View(tmdbMovie: sampleMovie)
        .modelContainer(for: [Playlist.self, Movie.self], inMemory: true) // in-memory SwiftData for preview
}
