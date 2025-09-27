//
//  NetworkService.swift
//  MyMovieList
//
//  Created by Hasna Paramesti Ahmad on 08/05/25.
//
//
//import Foundation
//import Combine
//

import SwiftUI
import Combine
import SwiftData

class NetworkService {
    
    private let apiKey = "fea54f5395dd12d87dbda427348ce4f6"  // Ganti dengan API key Anda
    private let baseURL = "https://api.themoviedb.org/3/movie/"
    
    func fetchMovieDetail(movieID: Int) -> AnyPublisher<Runtime, Error> {
        let url = URL(string: "\(baseURL)\(movieID)?api_key=\(apiKey)&language=en-US")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Runtime.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
       static let shared = NetworkService()
    
       func getMovieProviders(movieId: Int) -> AnyPublisher<[ProviderInfo], Error> {
           guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)/watch/providers?api_key=\(apiKey)") else {
               return Fail(error: NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: APIError.invalidUrl]))
                   .eraseToAnyPublisher()
           }
           
           return URLSession.shared.dataTaskPublisher(for: url)
               .map(\.data)
               .decode(type: ProviderResponse.self, decoder: JSONDecoder())
               .tryMap { response in
                   if let indonesiaProviders = response.results["ID"] {
                       return indonesiaProviders.flatrate ?? []
                   } else {
                       return []
                   }
               }
               .receive(on: DispatchQueue.main)
               .eraseToAnyPublisher()
       }
    

    
    func getMovieVideos(movieId: Int) -> AnyPublisher<[Video], Error> {
            guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=\(apiKey)") else {
                return Fail(error: NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: APIError.invalidUrl]))
                    .eraseToAnyPublisher()
            }
            
            return URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: VideoResponse.self, decoder: JSONDecoder())
                .map { response in
                    return response.results.filter { $0.type == "Trailer" }
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    

    
}

enum APIError: Error {
    case invalidUrl
}
