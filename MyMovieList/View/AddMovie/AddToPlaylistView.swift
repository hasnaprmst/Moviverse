//
//  AddToPlaylistView.swift
//  MyMovieList
//
//  Created by Hasna Paramesti Ahmad on 05/05/25.
//

import SwiftUI
import SwiftData

struct AddToPlaylistView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @Query var playlists: [Playlist]
    
    let tmdbMovie: TMDBMovie

    @State private var selectedPlaylists: Set<Playlist> = []
    @State private var showAlert = false
    @State private var addedToPlaylistNames: [String] = []
    @State private var showCreateNewPlaylist = false
    
    @EnvironmentObject var router: Router
    
    var sortedMovies: [Movie] {
        playlists.flatMap { $0.movies }.sorted(by: { $0.dateAdded < $1.dateAdded })
    }
    
    var firstFourPosters: [URL?] {
        Array(sortedMovies.prefix(4)).map { movie in
            if let path = movie.posterPath {
                return URL(string: "https://image.tmdb.org/t/p/w200\(path)")
            } else {
                return nil
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(spacing: 0) {
                        HStack(spacing: 16) {
                            Button(action: {
                                showCreateNewPlaylist = true
                            }) {
                                HStack(spacing: 16) {
                                    ZStack(alignment: .center) {
                                        Rectangle()
                                            .frame(width: 80, height: 80)
                                            .foregroundColor(.gray)
                                            .opacity(0.2) // Adjust the opacity to your needs
                                            .cornerRadius(8)
                                        
                                        Image(systemName: "plus")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(Color("mainColor"))
                                            .fontWeight(.regular)
                                    }

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Create New Playlist")
                                            .font(.headline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 10)
                                    }
                                    .padding(.leading, 8) // Adjust text padding if needed
                                }
                                .contentShape(Rectangle())
                                .buttonStyle(PlainButtonStyle()) // Prevents default button styling
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity) // Ensures the entire HStack is clickable

                            }
                          
                        }
                        .padding(.leading, -50)
                        .padding(.bottom)
                        Divider()
                        
//                        Button("Create New Playlist") {
//                            showCreateNewPlaylist = true
//                        }
//                        .font(.headline)
//                        .fontWeight(.semibold)
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color("mainColor"))
//                        .cornerRadius(10)
//                        .padding()

                        ForEach(playlists) { playlist in
                            let movieAlreadyInPlaylist = playlist.movies.contains { $0.tmdbID == tmdbMovie.id }
                            Button {
                                if !movieAlreadyInPlaylist {
                                    if selectedPlaylists.contains(playlist) {
                                        selectedPlaylists.remove(playlist)
                                    } else {
                                        selectedPlaylists.insert(playlist)
                                    }
                                }
                            } label: {
                                HStack(spacing: 16) {
                                    HStack(alignment: .top, spacing: 16) {
                                        let posters = Array(playlist.movies.prefix(4)).compactMap { movie in
                                            movie.posterPath.flatMap { URL(string: "https://image.tmdb.org/t/p/w200\($0)") }
                                        }

                                        if posters.count < 4 {
                                            AsyncImage(url: posters[0]) { phase in
                                                switch phase {
                                                case .empty:
                                                    ProgressView().frame(width: 80, height: 80)
                                                case .success(let image):
                                                    image.resizable().scaledToFill().frame(width: 80, height: 80).clipped().cornerRadius(8)
                                                case .failure:
                                                    Image(systemName: "photo").resizable().scaledToFit().frame(width: 80, height: 80).foregroundColor(.gray)
                                                @unknown default:
                                                    EmptyView()
                                                }
                                            }
                                        } else {
                                            VStack(spacing: 0) {
                                                ForEach(0..<2, id: \.self) { row in
                                                    HStack(spacing: 0) {
                                                        ForEach(0..<2, id: \.self) { col in
                                                            let index = row * 2 + col
                                                            if index < posters.count {
                                                                AsyncImage(url: posters[index]) { phase in
                                                                    switch phase {
                                                                    case .empty:
                                                                        ProgressView().frame(width: 40, height: 40)
                                                                    case .success(let image):
                                                                        image.resizable().scaledToFill().frame(width: 40, height: 40).clipped()
                                                                    case .failure:
                                                                        Image(systemName: "photo").resizable().scaledToFit().frame(width: 40, height: 40).foregroundColor(.gray)
                                                                    @unknown default:
                                                                        EmptyView()
                                                                    }
                                                                }
                                                            } else {
                                                                Image(systemName: "photo").resizable().scaledToFit().frame(width: 40, height: 40).foregroundColor(.gray)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            .frame(width: 80, height: 80)
                                            .cornerRadius(8)
                                            .clipped()
                                        }
                                    }
                                    .padding(.horizontal)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(playlist.title)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                            .lineLimit(1)
                                        Text("\(playlist.movies.count) Movies")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }

                                    Spacer()
                                    
                                    if movieAlreadyInPlaylist {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.gray)
                                            .imageScale(.large)
                                    } else if selectedPlaylists.contains(playlist) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(Color("mainColor"))
                                            .imageScale(.large)
                                    } else {
                                        Image(systemName: "circle")
                                            .foregroundColor(.gray.opacity(0.5))
                                            .imageScale(.large)
                                    }
                                }
                                .padding()
                                .contentShape(Rectangle())
                                .opacity(movieAlreadyInPlaylist ? 0.5 : 1.0)
                            }
                            .disabled(movieAlreadyInPlaylist)
                            Divider()
                        }
                    }
                    .padding(.top, 10)
                }

                Spacer()
            }
            .navigationTitle("Add to Playlist")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        addMovieToPlaylists()
                    }
                    .disabled(selectedPlaylists.isEmpty)
                }
            }
            .sheet(isPresented: $showCreateNewPlaylist) {
                CreateNewPlaylist2View(tmdbMovie: tmdbMovie)
            }
            .alert("🎉 Film berhasil ditambahkan!", isPresented: $showAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                let list = addedToPlaylistNames.joined(separator: ", ")
                Text("\"\(tmdbMovie.title)\" telah ditambahkan ke playlist: \(list).")
            }
        }
    }

    private func addMovieToPlaylists() {
        let genres = tmdbMovie.genre_ids.compactMap { genreDictionary[$0] }
        addedToPlaylistNames = []

        for playlist in selectedPlaylists {
            if !playlist.movies.contains(where: { $0.tmdbID == tmdbMovie.id }) {
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

                newMovie.playlists.append(playlist)
                playlist.movies.append(newMovie)

                context.insert(newMovie)
                addedToPlaylistNames.append(playlist.title)
            }
        }

        do {
            try context.save()
            router.path.removeAll()
//            showAlert = true
            // simpen path disini buat balik ke mainview
        } catch {
            print("❌ Gagal menyimpan context: \(error.localizedDescription)")
        }
    }
}

