////
////  PlaylistView.swift
////  MyMovieList
////
////  Created by Hasna Paramesti Ahmad on 05/05/25.
////
//
//import SwiftUI
//import SwiftData
//
//struct PlaylistView: View {
//    @Query var playlists: [Playlist]
//    @Environment(\.modelContext) var modelContext
//
//    @State private var showDeleteAlert = false
//    @State private var playlistToDelete: Playlist?
//
//    var body: some View {
//        NavigationStack {
//            List {
//                ForEach(playlists) { playlist in
//                    NavigationLink(destination: PlaylistDetailView(playlist: playlist)) {
//                        VStack(alignment: .leading, spacing: 8) {
//                            HStack {
//                                Text(playlist.title)
//                                    .font(.title3)
//                                    .lineLimit(1)
//                                    .bold()
//                                    .truncationMode(.tail)
//                                
//                                Spacer()
//                                
//                                Text("\(playlist.movies.count) movie\(playlist.movies.count == 1 ? "" : "s")")
//                                    .font(.subheadline)
//                                    .foregroundColor(.gray)
//                            }
//                            
//                            HStack {
//                                ForEach(playlist.movies.prefix(4), id: \.id) { movie in
//                                    if let posterPath = movie.posterPath {
//                                        let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
//                                        AsyncImage(url: imageUrl) { image in
//                                            image.resizable()
//                                                .frame(width: 60, height: 90)
//                                                .clipShape(RoundedRectangle(cornerRadius: 6))
//                                        } placeholder: {
//                                            ProgressView()
//                                        }
//                                    }
//                                }
////                                if playlist.movies.count > 4 {
////                                    Text("+\(playlist.movies.count - 4)")
////                                        .font(.headline)
////                                        .foregroundColor(.primary)
////                                        .buttonStyle(.plain)
////                                }
//                            }
//                        }
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                    }
//                }
//                .onDelete { offsets in
//                    if let index = offsets.first {
//                        playlistToDelete = playlists[index]
//                        showDeleteAlert = true
//                    }
//                }
//            }
//            .navigationTitle("MyMovie")
//            .alert("Hapus Playlist?",
//                   isPresented: $showDeleteAlert,
//                   presenting: playlistToDelete
//            ) { playlist in
//                Button("Hapus", role: .destructive) {
//                    deletePlaylist(playlist)
//                }
//                Button("Batal", role: .cancel) {}
//            } message: { playlist in
//                Text("Playlist \"\(playlist.title)\" berisi \(playlist.movies.count) film. Yakin ingin menghapus?")
//            }
//        }
//    }
//    private func deletePlaylist(_ playlistToDelete: Playlist) {
//        for movie in playlistToDelete.movies {
//            // Putuskan relasi movie ke playlist ini
//            movie.playlists.removeAll { $0 == playlistToDelete }
//
//            // Hapus movie jika tidak ada di playlist lain
//            if movie.playlists.isEmpty {
//                modelContext.delete(movie)
//            }
//        }
//
//        modelContext.delete(playlistToDelete)
//
//        do {
//            try modelContext.save()
//        } catch {
//            print("❌ Gagal menyimpan context setelah hapus playlist: \(error)")
//        }
//    }
//}
//
//    
//
