////
////  EditPlaylistDetailView.swift
////  MyMovieList
////
////  Created by Hasna Paramesti Ahmad on 06/05/25.
////
//
//import SwiftUI
//import SwiftData
//
//struct EditPlaylistDetailView: View {
//    @Binding var playlist: Playlist
//    @Environment(\.dismiss) var dismiss
//    @Environment(\.modelContext) var modelContext
//
//    @State private var title: String = ""
//    @State private var notes: String = ""
//
//    var body: some View {
//        NavigationStack {
//            Form {
//                Section(header: Text("Judul Playlist")) {
//                    TextField("Judul", text: $title)
//                }
//
//                Section(header: Text("Catatan")) {
//                    TextField("Catatan (opsional)", text: $notes)
//                }
//
//                Section(header: Text("Film di Playlist")) {
//                    if playlist.movies.isEmpty {
//                        Text("Belum ada film di playlist ini.")
//                            .foregroundColor(.secondary)
//                    } else {
//                        ForEach(playlist.movies) { movie in
//                                HStack {
//                                    if let posterPath = movie.posterPath,
//                                       let url = URL(string: "https://image.tmdb.org/t/p/w200\(posterPath)") {
//                                        AsyncImage(url: url) { phase in
//                                            switch phase {
//                                            case .empty:
//                                                ProgressView().frame(width: 40, height: 60)
//                                            case .success(let image):
//                                                image.resizable().scaledToFill().frame(width: 40, height: 60).clipped().cornerRadius(8)
//                                            case .failure:
//                                                Image(systemName: "photo").resizable().scaledToFit().frame(width: 40, height: 60).foregroundColor(.gray)
//                                            @unknown default:
//                                                EmptyView()
//                                            }
//                                        }
//                                    } else {
//                                        Image(systemName: "photo").resizable().scaledToFit().frame(width: 40, height: 60).foregroundColor(.gray)
//                                    }
//                                    VStack(alignment: .leading, spacing: 2) {
//                                        Text(movie.title)
//                                            .font(.body)
//                                        if let year = movie.releaseDate?.prefix(4) {
//                                            Text("\(year)")
//                                                .font(.caption)
//                                                .foregroundColor(.secondary)
//                                        }
//                                    }
//                                }
//                            
//                        }
//                        .onDelete(perform: deleteMovie)
//                    }
//                }
//            }
//            .navigationTitle("Edit Playlist")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .confirmationAction) {
//                    Button("Simpan") {
//                        playlist.title = title
//                        playlist.notes = notes.isEmpty ? nil : notes
//                        dismiss()
//                    }
//                }
//            }
//            .onAppear {
//                title = playlist.title
//                notes = playlist.notes ?? ""
//            }
//        }
//    }
//    
//    private func deleteMovie(offsets: IndexSet) {
//        withAnimation {
//            playlist.movies.remove(atOffsets: offsets)
//        }
//    }
//}
//
//#Preview {
//    struct PreviewWrapper: View {
//        @State var sampleMovie = Movie(
//            title: "Inception",
//            overview: "A mind-bending thriller",
//            releaseDate: "2010-07-16",
//            genres: ["Action", "Sci-Fi"],
//            posterPath: "/path.jpg",
//            backdropPath: "/path.jpg",
//            tmdbID: 123,
//            voteAverage: 8.8
//        )
//
//        @State var samplePlaylist: Playlist = {
//            let playlist = Playlist(title: "Favoritku", notes: "Film yang harus ditonton")
//            playlist.movies.append(
//                Movie(
//                    title: "Inception",
//                    overview: "A mind-bending thriller",
//                    releaseDate: "2010-07-16",
//                    genres: ["Action", "Sci-Fi"],
//                    posterPath: "/path.jpg",
//                    backdropPath: "/path.jpg",
//                    tmdbID: 123,
//                    voteAverage: 8.8
//                )
//            )
//            return playlist
//        }()
//
//        var body: some View {
//            EditPlaylistDetailView(playlist: $samplePlaylist)
//        }
//    }
//
//    return PreviewWrapper()
//}
