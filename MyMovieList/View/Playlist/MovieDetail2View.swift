//
//  MovieDetail2View.swift
//  MyMovieList
//
//  Created by Hasna Paramesti Ahmad on 07/05/25.
//



import SwiftData
import Combine
import SwiftUI

struct MovieDetail2View: View {
    let movie: TMDBMovie
    let playlist: Playlist  // Playlist yang akan menerima film
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var router: Router
    
    @State private var showingAddSheet = false
    @State private var isExpanded = false
    @State private var trailers: [Video] = []
    @State private var providers: [ProviderInfo] = []
    @State private var selectedTrailerURL: URL? = nil
    @State private var cancellables = Set<AnyCancellable>()
    @State private var isLoadingTrailers = false
    @State private var errorMessage: String? = nil
    @State private var showAlertSuccess = false  // Untuk alert setelah berhasil menambah film

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ZStack(alignment: .bottomLeading) {  // Ubah alignment menjadi .bottomLeading
                    // Backdrop
                    let backdropURL = movie.backdrop_path.flatMap { URL(string: "https://image.tmdb.org/t/p/w500\($0)") }
                    if let url = backdropURL {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(height: 150)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 150)
                                    .opacity(0.8)
                                    .clipped()
                            case .failure:
                                Image(systemName: "photo") // Dummy asset in Assets.xcassets
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 150)
                                    .clipped()
                            @unknown default:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 150)
                                    .clipped()
                            }
                        }
                    } else {
                        Image("imagenotavailable")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 150)
                            .clipped()
                    }
                    
                    if isLoadingTrailers {
                        ProgressView("Loading trailer...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding(.top)
                    } else if let trailer = trailers.first {
                        Button(action: {
                            if let url = trailer.youtubeURL {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Image(systemName: "play.circle")  // Gunakan SF Symbol play.circle
                                .resizable()
                                .frame(width: 50, height: 50)  // Atur ukuran ikon
                                .foregroundColor(.white)  // Warna ikon
                                .padding()
                        }
                        .cornerRadius(8)  // Optional: round the corners for a more polished look
                        .padding(.bottom, 40)
                        .padding(.leading, 160)
                    } else if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.top)
                    } else {
                        Button("") {
                            
                        }
                    }
                    
                    
                    // Poster di kiri bawah
                    if let posterPath = movie.poster_path,
                       let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                        AsyncImage(url: imageUrl) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 90, height: 135)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 90, height: 135)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .shadow(radius: 4)
                                    .padding(.leading, 20)
                                    .padding(.bottom, -120)
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 90, height: 135)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .shadow(radius: 4)
                                    .padding(.leading, 20)
                                    .padding(.bottom, -120)
                            @unknown default:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 90, height: 135)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .shadow(radius: 4)
                                    .padding(.leading, 20)
                                    .padding(.bottom, -120)
                            }
                        }
                    } else {
                        Image("posterempty")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 90, height: 135)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 4)
                            .padding(.leading, 20)
                            .padding(.bottom, -120)
                    }

                }
                Spacer(minLength: 10)
                // Judul, Tahun, Genre
                VStack(alignment: .leading, spacing: 4) {
                    Text(movie.title)
                        .font(.title3)
                        .bold()
                        .lineLimit(3)
                        .truncationMode(.tail)
                        .padding(.leading,130)
                    
                    // Rata kiri
                    
                    // Tahun Rilis
                    if let date = movie.release_date {
                        HStack{
                            Image(systemName: "calendar")
                                .foregroundColor(.primary)
                            Text(date.prefix(4))
                                .font(.caption)
                                .foregroundColor(.primary)
                                .frame(alignment: .leading)
                            // Rata kiri
                        }
                        .padding(.leading,130)
                    }
                    
                    HStack{
                        Image(systemName: "star")
                            .foregroundColor(.primary)
                        
                        Text("\(String(format: "%.1f", movie.vote_average))/10")
                            .font(.caption)
                    }
                    .padding(.leading,130)
                    
                    // Genre Film
                    if !movie.genre_ids.isEmpty {
                        let genreNames = movie.genre_ids.compactMap { genreDictionary[$0] }
                        HStack{
                            Image(systemName: "film")
                                .foregroundColor(.primary)
                            Text(genreNames.prefix(3).joined(separator: ", "))
                                .font(.caption)
                                .foregroundColor(.primary)
                                .lineLimit(2)
                            // Rata kiri
                        }
                        .padding(.leading,130)
                    }
                
                    
                    
                    Spacer()
                    
                    // Overview Title
                    VStack{
                        Text("Synopsis")
                            .font(.headline)
                            .bold()
                            .padding(.top, 20)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.primary)
                        
                        // Isi Sinopsis
                        Text(getSynopsis())
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        // Tombol "See More / See Less"
                        Button(action: {
                            if movie.overview.count > 150 {
                                isExpanded.toggle() // Toggle only if the overview is longer than 150 characters
                            }
                        }) {
                            if movie.overview.count > 150 {
                                Text(isExpanded ? "See Less" : "See More")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                    .padding(.horizontal)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } else {
                                // No button for overviews shorter than 150 characters
                                EmptyView() // You can optionally hide the button altogether
                            }
                        }
                        
                        if !providers.isEmpty {
                            Text("Available On:")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .bold()
                                .padding(.horizontal)
                                .padding(.top)
                            
                            
                            HStack {
                                ForEach(providers) { provider in
                                    VStack {
                                        if let logoURL = provider.logoURL {
                                            AsyncImage(url: logoURL) { image in
                                                image.resizable()
                                                    .frame(width: 50, height: 50)
                                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                            } placeholder: {
                                                Color.gray.frame(width: 50, height: 50)
                                            }
                                        }
                                        Text(provider.provider_name)
                                            .font(.caption)
                                    }
                                    .frame(width: 80)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal,4)
                            
                            
                        } else {
                            Text("Available On:")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .bold()
                                .padding(.horizontal)
                                .padding(.top)
                            
                            Text("Provider tidak tersedia untuk film ini.")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                                .padding(.top)
                        }
                        
                    }
                    Spacer()
                }
                .onAppear {
                    fetchMovieTrailers()
                    fetchProviders()
                }
                .padding(.top, -40)
                
                
                // Button to Add to Playlist
                Button(action: {
                    addMovieToPlaylist() // Add movie to playlist when button is tapped
                }) {
                    Text("ADD TO PLAYLIST")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("secondColor"))
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color("mainColor").opacity(0.8))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }

            }
        }
        .navigationTitle("Detail Film")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func getSynopsis() -> String {
        if movie.overview.count <= 150 {
            return movie.overview // Directly return the overview if it's less than 150 characters
        } else {
            if isExpanded {
                return movie.overview // Show full overview
            } else {
                // Truncate the overview if it's longer than 150 characters
                let maxLength = 150
                let truncated = movie.overview.prefix(maxLength)
                return String(truncated) + "..." // Add "..." at the end
            }
        }
    }
    
    private func addMovieToPlaylist() {
        // Cek apakah movie sudah ada di playlist
        guard !playlist.movies.contains(where: { $0.tmdbID == movie.id }) else {
            dismiss()
            return
        }
        let genres = movie.genre_ids.compactMap { genreDictionary[$0] }
        
        let newMovie = Movie(
            title: movie.title,
            overview: movie.overview,
            releaseDate: movie.release_date,
            genres: genres,
            posterPath: movie.poster_path,
            backdropPath: movie.backdrop_path,
            tmdbID: movie.id,
            voteAverage: movie.vote_average
        )

        newMovie.playlists.append(playlist)
        playlist.movies.append(newMovie)

        context.insert(newMovie)

        do {
            try context.save()
            router.popToPlaylistDetail()
//            showAlertSuccess = true
        } catch {
            print("❌ Gagal menyimpan movie: \(error.localizedDescription)")
        }

//        dismiss() // kembali ke halaman sebelumnya (DetailPlaylistView)
    }
    
    
    func fetchMovieTrailers() {
        isLoadingTrailers = true
        NetworkService.shared.getMovieVideos(movieId: movie.id)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = "Failed to load trailers: \(error.localizedDescription)"
                    print("Error fetching trailers: \(error)")
                case .finished:
                    break
                }
                isLoadingTrailers = false
            }, receiveValue: { videos in
                self.trailers = videos
            })
            .store(in: &cancellables)
    }
    
    func fetchProviders() {
        NetworkService.shared.getMovieProviders(movieId: movie.id)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching providers: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { providers in
                self.providers = providers
            })
            .store(in: &cancellables)
    }
}
