import SwiftUI
import SwiftData

struct Playlist2View: View {
    @State var playlists: [Playlist] = []
    @Environment(\.modelContext) var modelContext
    @State private var refreshID = UUID()
    @State private var showDeleteAlert = false
    @State private var playlistToDelete: Playlist?
    @EnvironmentObject var router: Router

  
    var body: some View {
        NavigationStack {
            ScrollView () {
                LazyVStack(spacing: 16) {
                    ForEach(playlists.sorted(by: { $0.movies.count > $1.movies.count })) { playlist in
                        Button {
                            router.navigate(to: .playlistDetail(playlist: playlist))
                        } label: {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(playlist.title)
                                        .font(.headline)
                                    
                                    HStack(spacing: 8) {
                                        ForEach(playlist.movies.prefix(4), id: \.id) { movie in
                                            if let posterPath = movie.posterPath,
                                               let url = URL(string: "https://image.tmdb.org/t/p/w200\(posterPath)") {
                                                AsyncImage(url: url) { phase in
                                                    switch phase {
                                                    case .empty:
                                                        // Tampilkan placeholder saat gambar masih dalam proses pemuatan
                                                        Rectangle()
                                                            .fill(Color.gray.opacity(0.3))
                                                            .frame(width: 60, height: 90)
                                                            .cornerRadius(6)
                                                    case .success(let image):
                                                        // Gambar berhasil dimuat
                                                        image.resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: 60, height: 90)
                                                            .clipShape(RoundedRectangle(cornerRadius: 6))
                                                    case .failure:
                                                        // Tampilkan gambar gagal jika terjadi kesalahan
                                                        Rectangle()
                                                            .fill(Color.gray.opacity(0.3))
                                                            .frame(width: 60, height: 90)
                                                            .cornerRadius(6)
                                                            .overlay(ProgressView())
                                                    @unknown default:
                                                        EmptyView()
                                                    }
                                                }
                                            }
                                        }
                                        if playlist.movies.count > 5 {
                                            Text("+\(playlist.movies.count - 5)")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                            
                                        Spacer()
                                    }
                                                                
                                }
                                VStack{
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                        .padding(.top, 50)
                                }
                            }
                            .padding()
                            .background(Color(.gray.opacity(0.1)))
                            .cornerRadius(12)
                        }
                        .buttonStyle(.plain)
//                        .contextMenu {
//                            Button("Hapus Playlist", role: .destructive) {
//                                playlistToDelete = playlist
//                                showDeleteAlert = true
//                            }
//                        }
                    }
                }
                .padding()
                .id(refreshID)
            }
            .navigationTitle("MyMovie")
            .alert("Hapus Playlist?",
                   isPresented: $showDeleteAlert,
                   presenting: playlistToDelete
            ) { playlist in
                Button("Hapus", role: .destructive) {
                    deletePlaylist(playlist)
                }
                Button("Batal", role: .cancel) {}
            } message: { playlist in
                Text("Playlist \"\(playlist.title)\" berisi \(playlist.movies.count) film. Yakin ingin menghapus?")
            }
            .onAppear{
                loadPlaylist()
            }
        }
    }

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
        } catch {
            print("❌ Gagal menyimpan context setelah hapus playlist: \(error)")
        }
    }
    
    private func loadPlaylist() {
        let descriptor = FetchDescriptor<Playlist>(
            sortBy: [SortDescriptor(\.title)]
        )
        
        do {
            playlists = try modelContext.fetch(descriptor)
            refreshID = UUID()
            
        } catch {
            print(" Gagal Memuat Playlist: \(error)")
        }
        
    }
}
