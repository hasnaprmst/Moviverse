//
//  Provider.swift
//  MyMovieList
//
//  Created by Hasna Paramesti Ahmad on 08/05/25.
//


import Foundation

struct ProviderResponse: Codable {
    let results: [String: ProviderCountry]
}

struct ProviderCountry: Codable {
    let link: String?
    let flatrate: [ProviderInfo]?
}

struct ProviderInfo: Codable, Identifiable {
    let provider_id: Int
    let provider_name: String
    let logo_path: String?
    
    var id: Int { provider_id }
    
    var logoURL: URL? {
        return URL(string: "https://image.tmdb.org/t/p/w200\(logo_path ?? "")")
    }
}
