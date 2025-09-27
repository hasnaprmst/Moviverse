//
//  PlaylistDetailView.swift
//  MyMovieList
//
//  Created by Hasna Paramesti Ahmad on 05/05/25.
//
import SwiftUI
import SwiftData

struct PlaylistDetailView: View {
    @State var playlist: Playlist

    // state untuk modal sheet
    @State private var showingFilter = false
    @State private var showEditPlaylist: Bool = false
    @State private var showPickerMovie: Bool = false
    @State private var showAddMovie: Bool = false
    
    // state untuk filter movie
    @State private var selectedGenre: String? = nil
    @State private var selectedMood: String? = nil
    @State private var selectedEras: String? = nil
  
    
    // state untuk navigation path
    @State private var path = NavigationPath()
    @EnvironmentObject var router: Router
    
    var filteredMovies: [Movie] {
        playlist.movies.filter { movie in
            var matchesMood = true
            var matchesEras = true

            if let mood = selectedMood, let moodGenres = MoodData.moods[mood] {
                matchesMood = !Set(movie.genres).isDisjoint(with: moodGenres)
            }

            if let era = selectedEras {
                matchesEras = movie.releaseYearEra == era
            }

            return matchesMood && matchesEras
        }
    }
    
    var sortedMovies: [Movie] {
        playlist.movies.sorted(by: { $0.dateAdded < $1.dateAdded })
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
        VStack(alignment: .leading, spacing: 16) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .top, spacing: 16) {
                        if playlist.movies.count < 4 {
                            if let firstMovie = sortedMovies.first,
                               let posterPath = firstMovie.posterPath,
                               let url = URL(string: "https://image.tmdb.org/t/p/w200\(posterPath)") {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView().frame(width: 120, height: 120)
                                    case .success(let image):
                                        image.resizable().scaledToFill().frame(width: 120, height: 120).clipped().cornerRadius(8)
                                    case .failure:
                                        Image(systemName: "photo").resizable().scaledToFit().frame(width: 120, height: 120).foregroundColor(.gray)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            }
                        } else {
                            VStack(spacing: 0) {
                                ForEach(0..<2, id: \ .self) { row in
                                    HStack(spacing: 0) {
                                        ForEach(0..<2, id: \ .self) { col in
                                            let index = row * 2 + col
                                            if index < firstFourPosters.count, let url = firstFourPosters[index] {
                                                AsyncImage(url: url) { phase in
                                                    switch phase {
                                                    case .empty:
                                                        ProgressView().frame(width: 60, height: 60)
                                                    case .success(let image):
                                                        image.resizable().scaledToFill().frame(width: 60, height: 60).clipped()
                                                    case .failure:
                                                        Image(systemName: "photo").resizable().scaledToFit().frame(width: 60, height: 60).foregroundColor(.gray)
                                                    @unknown default:
                                                        EmptyView()
                                                    }
                                                }
                                            } else {
                                                Image(systemName: "photo").resizable().scaledToFit().frame(width: 60, height: 60).foregroundColor(.gray)
                                            }
                                        }
                                    }
                                }
                            }
                            .frame(width: 120, height: 120)
                            .cornerRadius(8)
                            .clipped()
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(playlist.title)
                                .font(.title3)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .lineLimit(2)
                            
                            Text("\(playlist.movies.count) Movie\(playlist.movies.count == 1 ? "" : "s")")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Button {
                                showPickerMovie = true
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "dice")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                    Text("RANDOM PICKER")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                }
                               
                                .foregroundColor(playlist.movies.count < 2 ? .gray : Color("secondColor"))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(playlist.movies.count < 2 ? Color.gray.opacity(0.3) : Color("mainColor"))
                                .cornerRadius(10)
                            }
                            .disabled(playlist.movies.count < 2)
                            
                            
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal)
                    
                    ZStack(alignment: .topLeading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: 354, height: 100)
                            .cornerRadius(16)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Description")
                                .font(.body)
                                .bold()
                                .foregroundColor(.white)
                            Text(playlist.notes?.isEmpty == false ? playlist.notes! : "no description")
                                .font(.body)
                                .foregroundColor(.white)
                             
                        }
                        .padding()
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Movies")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        HStack {
                            if let mood = selectedMood, !mood.isEmpty {
                                Text(mood)
                                    .font(.subheadline)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color("mainColor").opacity(0.2))
                                    .foregroundColor(Color("mainColor"))
                                    .cornerRadius(8)
                            }
                            
                            if let era = selectedEras, !era.isEmpty {
                                Text(era)
                                    .font(.subheadline)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color("mainColor").opacity(0.2))
                                    .foregroundColor(Color("mainColor"))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                
                    if filteredMovies.isEmpty {
                        VStack(spacing: 4) {
                            Image("filterNil")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 180, height: 150)
                            Text("Try changing the filter or reset")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .padding(.top, 10)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        Spacer()
                    } else {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 20) {
                            ForEach(filteredMovies, id: \ .id) { movie in
                                VStack(spacing: 6) {
                                    if let posterPath = movie.posterPath,
                                       let url = URL(string: "https://image.tmdb.org/t/p/w200\(posterPath)") {
                                        AsyncImage(url: url) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView().frame(width: 80, height: 120)
                                            case .success(let image):
                                                image.resizable().scaledToFill().frame(width: 80, height: 120).clipped().cornerRadius(8)
                                            case .failure:
                                                Image(systemName: "photo").resizable().scaledToFit().frame(width: 80, height: 120).foregroundColor(.gray)
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                    } else {
                                        Image(systemName: "photo").resizable().scaledToFit().frame(width: 80, height: 120).foregroundColor(.gray)
                                    }
                                    
                                    Text(movie.title)
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(1)
                                        .frame(maxWidth: 80, minHeight: 1, alignment: .top)
                                    
                                    if let year = movie.releaseDate?.prefix(4) {
                                        Text("(\(year))").font(.caption2).foregroundColor(.white)
                                    } else {
                                        Text("(N/A)").font(.caption2).foregroundColor(.white)
                                    }
                                }
                                .frame(width: 80)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
        }
        .navigationTitle("Playlist Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { router.navigate(to: .searchInPlaylist(playlist: playlist)) } label: { Image(systemName: "plus") }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { showingFilter = true } label: { Image(systemName: "line.3.horizontal.decrease") }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { showEditPlaylist = true } label: { Image(systemName: "pencil") }
            }
        }
        .sheet(isPresented: $showingFilter) {
            FilterInPlaylistView(
                selectedGenre: $selectedGenre,
                selectedMood: $selectedMood,
                selectedEras: $selectedEras,
                availableGenres: uniqueGenres(from: playlist.movies)
            )
        }
        .sheet(isPresented: $showPickerMovie) {
            RandomPickerPlaylistView(playlist: playlist)
        }
//        .navigationDestination(isPresented: $showAddMovie) {
//            Search2View(playlist: playlist)
//        }
        .sheet(isPresented: $showEditPlaylist) {
            EditPlaylistDetail2View(playlist: $playlist)
        }
    }

    func uniqueGenres(from movies: [Movie]) -> [String] {
        Set(movies.flatMap { $0.genres }).sorted()
    }
}
