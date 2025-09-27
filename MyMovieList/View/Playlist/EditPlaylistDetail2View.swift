//
//  EditPlaylistDetailView.swift
//  MyMovieList
//
//  Created by Hasna Paramesti Ahmad on 06/05/25.
//

import SwiftUI
import SwiftData

struct EditPlaylistDetail2View: View {
    @Binding var playlist: Playlist
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var router: Router
    
    @State private var title: String = ""
    @State private var notes: String = ""
    @State private var showDeleteConfirmation = false
    @State private var showDeleteMovie = false
    @State private var movieToDelete: Movie?
    @State private var playlisttoDelete: Playlist?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Title input
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Title")
                            .font(.headline)
                        TextField("Enter playlist title", text: $title)
                            .onChange(of: title) { newValue in
                                if newValue.count > 30 { // Set the character limit here
                                    title = String(newValue.prefix(30)) // Limit to 30 characters
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }

                    // Notes input
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Description")
                            .font(.headline)
                        
                        TextField("Enter description (optional)", text: $notes, axis: .vertical)
                            .lineLimit(3...6)
                            .onChange(of: notes) { newValue in
                                if newValue.count > 70 { // Set your character limit here
                                    notes = String(newValue.prefix(70)) // Limit to 200 characters
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }

                    // Movie list
                    if !playlist.movies.isEmpty {
                        Text("Movies in Playlist")
                            .font(.headline)
                            .padding(.top)

                        let movies = playlist.movies
                        ForEach(movies) { movie in
                            MovieRow(movie: movie) {
                                movieToDelete = movie
                                showDeleteMovie = true
                            }
                        }
                    } else {
                        Text("No movies in this playlist yet.")
                            .foregroundColor(.secondary)
                            .padding(.top)
                    }

                    // Tombol Delete Playlist
//                    Button(role: .destructive) {
//                        showDeleteConfirmation = true
//                    } label: {
//                        Text("Delete Playlist")
//                            .font(.headline)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color.red.opacity(0.1))
//                            .foregroundColor(.red)
//                            .cornerRadius(10)
//                    }
//                    .padding(.top)
                }
                .padding()
            }
            .padding(4)
            .navigationTitle("Edit Playlist")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        playlist.title = title
                        playlist.notes = notes.isEmpty ? nil : notes
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                title = playlist.title
                notes = playlist.notes ?? ""
            }
            .alert("Remove Movie?", isPresented: $showDeleteMovie) {
                Button("Delete", role: .destructive) {
                    if let movie = movieToDelete {
                        deleteMovie(movie)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                if let movie = movieToDelete {
                    Text("Are you sure want to remove movie \"\(movie.title)\" from the playlist \"\(playlist.title)\"?")
                } else {
                    Text("Yakin ingin menghapus film ini dari playlist?")
                }
            }
            .alert("Are you sure you want to delete this playlist?", isPresented: $showDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    deletePlaylist(playlist)
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }

    // MARK: - Hapus Movie
    private func deleteMovie(_ movie: Movie) {
        if let index = playlist.movies.firstIndex(where: { $0.id == movie.id }) {
            playlist.movies.remove(at: index)

            // Putuskan relasi movie -> playlist
            movie.playlists.removeAll { $0.id == playlist.id }

            // Hapus movie jika tidak ada playlist lain
            if movie.playlists.isEmpty {
                modelContext.delete(movie)
            }

            // Jika playlist jadi kosong, hapus playlist
            if playlist.movies.isEmpty {
                modelContext.delete(playlist)

                do {
                    try modelContext.save()
                    dismiss() // keluar dari view
                    router.reset()
                } catch {
                    print("❌ Gagal menyimpan setelah hapus movie dan playlist kosong: \(error)")
                }

            } else {
                // Playlist masih ada film lain, cukup simpan
                do {
                    try modelContext.save()
                } catch {
                    print("❌ Gagal menyimpan context setelah hapus movie: \(error)")
                }
            }
        }
    }

    // MARK: - Hapus Playlist
    private func deletePlaylist(_ playlistToDelete: Playlist) {
        for movie in playlistToDelete.movies {
            movie.playlists.removeAll { $0 == playlistToDelete }
            if movie.playlists.isEmpty {
                modelContext.delete(movie)
            }
        }

        modelContext.delete(playlistToDelete)

        do {
            try modelContext.save()
            dismiss() // keluar dari view setelah berhasil
        } catch {
            print("❌ Gagal menyimpan context setelah hapus playlist: \(error)")
        }
    }

    // MARK: - View per Movie
    @ViewBuilder
    private func MovieRow(movie: Movie, onDelete: @escaping () -> Void) -> some View {
        HStack(spacing: 12) {
            if let posterPath = movie.posterPath,
               let url = URL(string: "https://image.tmdb.org/t/p/w200\(posterPath)") {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 68, height: 101)
                    case .success(let image):
                        image.resizable()
                            .scaledToFill()
                            .frame(width: 68, height: 101)
                            .clipped()
                            .cornerRadius(8)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 68, height: 101)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 68, height: 101)
                    .foregroundColor(.gray)
            }

            VStack(alignment: .leading) {
                Text(movie.title)
                    .font(.body)
                if let year = movie.releaseDate?.prefix(4) {
                    Text("\(year)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var sampleMovie = Movie(

            title: "Inception",
            overview: "A mind-bending thriller",
            releaseDate: "2010-07-16",
            genres: ["Action", "Sci-Fi"],
            posterPath: "/path.jpg",
            backdropPath: "/path.jpg",
            tmdbID: 123,
            voteAverage: 8.8
            
        )

        @State var samplePlaylist: Playlist = {
            let playlist = Playlist(title: "Favoritku", notes: "Film yang harus ditonton")
            playlist.movies.append(
                Movie(
                    title: "Inception",
                    overview: "A mind-bending thriller",
                    releaseDate: "2010-07-16",
                    genres: ["Action", "Sci-Fi"],
                    posterPath: "/path.jpg",
                    backdropPath: "/path.jpg",
                    tmdbID: 123,
                    voteAverage: 8.8
                )
            )
            return playlist
        }()

        var body: some View {
            EditPlaylistDetail2View(playlist: $samplePlaylist)
        }
    }

    return PreviewWrapper()
}
