//
//  MovieDetailViewModel.swift
//  MyMovieList
//
//  Created by M Riza Levandy on 10/05/25.
//

import Foundation
import Combine


class MovieDetailViewModel: ObservableObject {
    @Published var movieDetail: Runtime?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let movieService = NetworkService()
    
    func fetchMovieDetail(movieID: Int) {
        self.isLoading = true
        movieService.fetchMovieDetail(movieID: movieID)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
                self.isLoading = false
            }, receiveValue: { movieDetail in
                self.movieDetail = movieDetail
            })
            .store(in: &cancellables)
    }
}
