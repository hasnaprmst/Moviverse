//
//  Route.swift
//  MyMovieList
//
//  Created by M Riza Levandy on 12/05/25.
//

import Foundation
import Combine
import SwiftUI

enum Route: Hashable {
    case search
    case detailFromMain(movie: TMDBMovie)
    case playlistDetail(playlist: Playlist)
    case searchInPlaylist(playlist: Playlist)
    case detailFromPlaylist(movie: TMDBMovie, playlist: Playlist)
}

class Router: ObservableObject {
    @Published var path : [Route] = []
    
    func navigate(to route: Route) {
        path.append(route)
    }
    
//    func navigateToMovieDetail(movie: Movie, playlist: Playlist) {
//        let tmdbMovie = TMDBMovie(from: movie) // Konversi dari Movie ke TMDBMovie
//        path.append(.detailFromPlaylist(movie: tmdbMovie, playlist: playlist))
//    }
    
//    func navigateToDetail(movie: Movie) {
//        path.append(.movieDetail(movie: TMDBMovie(from: movie)))
//    }
    
    func popToPlaylistDetail() {
        while let last = path.last {
            if case .playlistDetail = last {
                break // ketemu playlist detail, berhenti
            }
            path.removeLast()
        }
    }
    
    func reset() {
        path.removeAll()
    }
}

