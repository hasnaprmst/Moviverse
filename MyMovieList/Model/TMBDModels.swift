//
//  TMDBSearchResponse.swift
//  MyMovieList
//
//  Created by Hasna Paramesti Ahmad on 05/05/25.
//


import Foundation

struct TMDBSearchResponse: Codable {
    let results: [TMDBMovie]
}

struct TMDBMovie: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let overview: String
    let release_date: String?
    let genre_ids: [Int]
    let poster_path: String?
    let backdrop_path: String?
    let vote_average: Float
}


let genreDictionary: [Int: String] = [
    28: "Action",
    12: "Adventure",
    16: "Animation",
    35: "Comedy",
    80: "Crime",
    99: "Documentary",
    18: "Drama",
    10751: "Family",
    14: "Fantasy",
    36: "History",
    27: "Horror",
    9648: "Mystery",
    10749: "Romance",
    878: "Science Fiction",
    10770: "TV Movie",
    53: "Thriller",
    10752: "War",
    37: "Western",
    10402: "Music"
]

