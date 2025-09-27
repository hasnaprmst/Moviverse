////
////  PlaylistDetailView 2.swift
////  MyMovieList
////
////  Created by Hasna Paramesti Ahmad on 08/05/25.
////
//
//import SwiftUI
//import SwiftData
//
//struct PlaylistDetail2View: View {
//    @State var playlist: Playlist
//
//    @State private var showingFilter = false
//    @State private var showEditPlaylist: Bool = false
//    @State private var showPickerMovie: Bool = false
//    @State private var showAddMovie: Bool = false
//    @State private var selectedGenre: String? = nil
//    @State private var selectedMood: String? = nil
//    @State private var path = NavigationPath()
//
//    var filteredMovies: [Movie] {
//        if let mood = selectedMood {
//            return playlist.movies.filter { $0.genres.contains(mood) }
//        } else {
//            return playlist.movies
//        }
//    }
//
//    var sortedMovies: [Movie] {
//        playlist.movies.sorted(by: { $0.dateAdded < $1.dateAdded })
//    }
//
//    var firstFourPosters: [URL?] {
//        Array(sortedMovies.prefix(4)).map { movie in
//            if let path = movie.posterPath {
//                return URL(string: "https://image.tmdb.org/t/p/w200\(path)")
//            } else {
//                return nil
//            }
//        }
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            if filteredMovies.isEmpty {
//                ScrollView {
//                    VStack(alignment: .leading, spacing: 20) {
//                        HStack(alignment: .top, spacing: 16) {
//                            if playlist.movies.count < 4 {
//                                if let firstMovie = sortedMovies.first,
//                                   let posterPath = firstMovie.posterPath,
//                                   let url = URL(string: "https://image.tmdb.org/t/p/w200\(posterPath)") {
//                                    AsyncImage(url: url) { phase in
//                                        switch phase {
//                                        case .empty:
//                                            ProgressView().frame(width: 120, height: 120)
//                                        case .success(let image):
//                                            image.resizable().scaledToFill().frame(width: 120, height: 120).clipped().cornerRadius(8)
//                                        case .failure:
//                                            Image(systemName: "photo").resizable().scaledToFit().frame(width: 120, height: 120).foregroundColor(.gray)
//                                        @unknown default:
//                                            EmptyView()
//                                        }
//                                    }
//                                }
//                            } else {
//                                VStack(spacing: 0) {
//                                    ForEach(0..<2, id: \ .self) { row in
//                                        HStack(spacing: 0) {
//                                            ForEach(0..<2, id: \ .self) { col in
//                                                let index = row * 2 + col
//                                                if index < firstFourPosters.count, let url = firstFourPosters[index] {
//                                                    AsyncImage(url: url) { phase in
//                                                        switch phase {
//                                                        case .empty:
//                                                            ProgressView().frame(width: 60, height: 60)
//                                                        case .success(let image):
//                                                            image.resizable().scaledToFill().frame(width: 60, height: 60).clipped()
//                                                        case .failure:
//                                                            Image(systemName: "photo").resizable().scaledToFit().frame(width: 60, height: 60).foregroundColor(.gray)
//                                                        @unknown default:
//                                                            EmptyView()
//                                                        }
//                                                    }
//                                                } else {
//                                                    Image(systemName: "photo").resizable().scaledToFit().frame(width: 60, height: 60).foregroundColor(.gray)
//                                                }
//                                            }
//                                        }
//                                    }
//                                }
//                                .frame(width: 120, height: 120)
//                                .cornerRadius(8)
//                                .clipped()
//                            }
//
//                            VStack(alignment: .leading, spacing: 8) {
//                                Text(playlist.title)
//                                    .font(.title3)
//                                    .foregroundColor(.white)
//                                    .fontWeight(.bold)
//                                    .lineLimit(2)
//
//                                Text("\(playlist.movies.count) Movie\(playlist.movies.count == 1 ? "" : "s")")
//                                    .font(.subheadline)
//                                    .foregroundColor(.gray)
//
//                                Button {
//                                    showPickerMovie = true
//                                } label: {
//                                    HStack(spacing: 8) {
//                                        Image(systemName: "dice")
//                                            .resizable()
//                                            .frame(width: 15, height: 15)
//                                        Text("Randomize Now")
//                                            .font(.subheadline)
//                                            .fontWeight(.semibold)
//                                    }
//                                    .foregroundColor(.black)
//                                    .padding()
//                                    .frame(maxWidth: .infinity)
//                                    .background(Color("mainColor"))
//                                    .cornerRadius(10)
//                                }
//                            }
//                            .padding(.top, 8)
//                        }
//                        .padding(.horizontal)
//
//                        ZStack(alignment: .topLeading) {
//                            Rectangle()
//                                .fill(Color.gray.opacity(0.1))
//                                .frame(width: 354, height: 71)
//                                .cornerRadius(16)
//                            
//                            VStack(alignment: .leading, spacing: 4) {
//                                Text("Description")
//                                    .font(.body)
//                                    .bold()
//                                    .foregroundColor(Color("mainColor"))
//                                Text(playlist.notes?.isEmpty == false ? playlist.notes! : "Tidak ada catatan")
//                                    .font(.body)
//                                    .foregroundColor(Color("mainColor"))
//                            }
//                            .padding()
//                        }
//                        .padding(.horizontal)
//                    }
//                    .padding(.top)
//                }
//                HStack(spacing: 8) {
//                    Text("Movies")
//                        .font(.headline)
//                        .bold()
//                        .foregroundColor(.white)
//
//                    if let mood = selectedMood, !mood.isEmpty {
//                        Text(mood)
//                            .font(.caption)
//                            .padding(.horizontal, 8)
//                            .padding(.vertical, 4)
//                            .background(Color("mainColor").opacity(0.2))
//                            .foregroundColor(Color("mainColor"))
//                            .cornerRadius(8)
//                    }
//                }
//                .padding(.horizontal)
//                
//                VStack(spacing: 4) {
//                    Image("filterNil")
//                        .resizable()
//                        .frame(width: 150, height: 150)
//                    Text("Coba ganti filter-nya atau reset.")
//                        .foregroundColor(.gray)
//                }
//                .padding()
//                .padding(.top, -40)
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                Spacer()
//            } else {
//                ScrollView {
//                    VStack(alignment: .leading, spacing: 20) {
//                        HStack(alignment: .top, spacing: 16) {
//                            if playlist.movies.count < 4 {
//                                if let firstMovie = sortedMovies.first,
//                                   let posterPath = firstMovie.posterPath,
//                                   let url = URL(string: "https://image.tmdb.org/t/p/w200\(posterPath)") {
//                                    AsyncImage(url: url) { phase in
//                                        switch phase {
//                                        case .empty:
//                                            ProgressView().frame(width: 120, height: 120)
//                                        case .success(let image):
//                                            image.resizable().scaledToFill().frame(width: 120, height: 120).clipped().cornerRadius(8)
//                                        case .failure:
//                                            Image(systemName: "photo").resizable().scaledToFit().frame(width: 120, height: 120).foregroundColor(.gray)
//                                        @unknown default:
//                                            EmptyView()
//                                        }
//                                    }
//                                }
//                            } else {
//                                VStack(spacing: 0) {
//                                    ForEach(0..<2, id: \ .self) { row in
//                                        HStack(spacing: 0) {
//                                            ForEach(0..<2, id: \ .self) { col in
//                                                let index = row * 2 + col
//                                                if index < firstFourPosters.count, let url = firstFourPosters[index] {
//                                                    AsyncImage(url: url) { phase in
//                                                        switch phase {
//                                                        case .empty:
//                                                            ProgressView().frame(width: 60, height: 60)
//                                                        case .success(let image):
//                                                            image.resizable().scaledToFill().frame(width: 60, height: 60).clipped()
//                                                        case .failure:
//                                                            Image(systemName: "photo").resizable().scaledToFit().frame(width: 60, height: 60).foregroundColor(.gray)
//                                                        @unknown default:
//                                                            EmptyView()
//                                                        }
//                                                    }
//                                                } else {
//                                                    Image(systemName: "photo").resizable().scaledToFit().frame(width: 60, height: 60).foregroundColor(.gray)
//                                                }
//                                            }
//                                        }
//                                    }
//                                }
//                                .frame(width: 120, height: 120)
//                                .cornerRadius(8)
//                                .clipped()
//                            }
//
//                            VStack(alignment: .leading, spacing: 8) {
//                                Text(playlist.title)
//                                    .font(.title3)
//                                    .foregroundColor(Color("mainColor"))
//                                    .fontWeight(.bold)
//                                    .lineLimit(2)
//
//                                Text("\(playlist.movies.count) Movie\(playlist.movies.count == 1 ? "" : "s")")
//                                    .font(.subheadline)
//                                    .foregroundColor(.gray)
//
//                                Button {
//                                    showPickerMovie = true
//                                } label: {
//                                    HStack(spacing: 8) {
//                                        Image(systemName: "dice")
//                                            .resizable()
//                                            .frame(width: 15, height: 15)
//                                        Text("Randomize Now")
//                                            .font(.subheadline)
//                                            .fontWeight(.semibold)
//                                    }
//                                    .foregroundColor(.black)
//                                    .padding()
//                                    .frame(maxWidth: .infinity)
//                                    .background(Color("mainColor"))
//                                    .cornerRadius(10)
//                                }
//                            }
//                            .padding(.top, 8)
//                        }
//                        .padding(.horizontal)
//
//                        ZStack(alignment: .topLeading) {
//                            Rectangle()
//                                .fill(Color.gray.opacity(0.1))
//                                .frame(width: 354, height: 71)
//                                .cornerRadius(16)
//                            
//                            VStack(alignment: .leading, spacing: 4) {
//                                Text("Description")
//                                    .font(.headline)
//                                    .bold()
//                                    .foregroundColor(Color("mainColor"))
//                                Text(playlist.notes?.isEmpty == false ? playlist.notes! : "Tidak ada catatan")
//                                    .font(.subheadline)
//                                    .foregroundColor(Color("mainColor"))
//                            }
//                            .padding()
//                            Spacer()
//                        }
//                        .padding(.horizontal)
//                        
//                        Text("Movies")
//                            .font(.headline)
//                            .bold()
//                            .foregroundColor(.white)
//                            .padding(.horizontal)
//
//                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 20) {
//                            ForEach(filteredMovies, id: \ .id) { movie in
//                                VStack(spacing: 6) {
//                                    if let posterPath = movie.posterPath,
//                                       let url = URL(string: "https://image.tmdb.org/t/p/w200\(posterPath)") {
//                                        AsyncImage(url: url) { phase in
//                                            switch phase {
//                                            case .empty:
//                                                ProgressView().frame(width: 80, height: 120)
//                                            case .success(let image):
//                                                image.resizable().scaledToFill().frame(width: 80, height: 120).clipped().cornerRadius(8)
//                                            case .failure:
//                                                Image(systemName: "photo").resizable().scaledToFit().frame(width: 80, height: 120).foregroundColor(.gray)
//                                            @unknown default:
//                                                EmptyView()
//                                            }
//                                        }
//                                    } else {
//                                        Image(systemName: "photo").resizable().scaledToFit().frame(width: 80, height: 120).foregroundColor(.gray)
//                                    }
//
//                                    Text(movie.title)
//                                        .font(.caption)
//                                        .multilineTextAlignment(.center)
//                                        .lineLimit(1)
//                                        .frame(maxWidth: 80, minHeight: 1, alignment: .top)
//
//                                    if let year = movie.releaseDate?.prefix(4) {
//                                        Text("(\(year))").font(.caption2).foregroundColor(.black)
//                                    } else {
//                                        Text("(N/A)").font(.caption2).foregroundColor(.black)
//                                    }
//                                }
//                                .frame(width: 80)
//                            }
//                        }
//                        .padding(.horizontal)
//                    }
//                    .padding(.top)
//                }
//            }
//        }
//        .toolbar {
//            ToolbarItem(placement: .topBarTrailing) {
//                Button { showingFilter = true } label: { Image(systemName: "slider.horizontal.3") }
//            }
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button { showAddMovie = true } label: { Image(systemName: "plus") }
//            }
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button { showEditPlaylist = true } label: { Image(systemName: "pencil") }
//            }
//        }
//        .sheet(isPresented: $showingFilter) {
//            FilterInPlaylistView(
//                selectedGenre: $selectedGenre,
//                selectedMood: $selectedMood,
//                availableGenres: uniqueGenres(from: playlist.movies)
//            ) { genre, mood in
//                selectedGenre = genre
//                selectedMood = mood
//            }
//        }
//        .sheet(isPresented: $showPickerMovie) {
//            RandomPickerPlaylistView(playlist: playlist)
//        }
//        .navigationDestination(isPresented: $showAddMovie) {
//            Search2View(playlist: playlist)
//        }
//        .navigationDestination(isPresented: $showEditPlaylist) {
//            EditPlaylistDetail2View(playlist: $playlist)
//        }
//    }
//
//    func uniqueGenres(from movies: [Movie]) -> [String] {
//        Set(movies.flatMap { $0.genres }).sorted()
//    }
//}
