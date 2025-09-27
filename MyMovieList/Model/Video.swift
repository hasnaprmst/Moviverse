//
//  Video.swift
//  MyMovieList
//
//  Created by Hasna Paramesti Ahmad on 08/05/25.
//
//
import Foundation

struct VideoResponse: Codable {
    let results: [Video]
}

struct Video: Codable, Identifiable {
    let id: String
    let key: String
    let name: String
    let site: String
    let type: String
    
    var youtubeURL: URL? {
        if site == "YouTube" {
            return URL(string: "https://www.youtube.com/watch?v=\(key)")
        } else {
            return nil
        }
    }
}
