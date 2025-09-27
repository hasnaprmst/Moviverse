//
//  Playlist.swift
//  MyMovieList
//
//  Created by Hasna Paramesti Ahmad on 05/05/25.
//

import Foundation
import SwiftData

@Model
class Playlist {
    var title: String
    var notes: String?
//    @Relationship(deleteRule: .cascade) var movies: [Movie]
    @Relationship var movies: [Movie] = []

    init(title: String, notes: String? = nil) {
        self.title = title
        self.notes = notes
        self.movies = []
    }
}


//@Model
//class Playlist {
//    @Attribute(.unique) var id: UUID = UUID()
//    var title: String
//    var note: String?
//    var movies: [Movie] = []
//    
//    init(title: String, note: String? = nil, movies: [Movie] = []) {
//        self.title = title
//        self.note = note
//        self.movies = movies
//    }
//}

