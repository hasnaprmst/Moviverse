//
//  MovieSearchViewModel.swift
//  MyMovieList
//
//  Created by Hasna Paramesti Ahmad on 05/05/25.
//

import Foundation
import Combine
import SwiftData

//@MainActor
class MovieSearchViewModel: ObservableObject {
    @Published var movies: [TMDBMovie] = []
    
    private let apiKey = "fea54f5395dd12d87dbda427348ce4f6"
    
    func searchMovies(query: String) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(encodedQuery)"
        guard let url = URL(string: urlString) else { return }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoded = try JSONDecoder().decode(TMDBSearchResponse.self, from: data)
                DispatchQueue.main.async {
                    self.movies = decoded.results
                }
            } catch {
                print("Error fetching movies: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    
}
