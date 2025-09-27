//
//  Movie.swift
//  MyMovieList
//
//  Created by Hasna Paramesti Ahmad on 05/05/25.
//

import Foundation
import SwiftData


@Model
class Movie {
    var title: String
    var overview: String
    var releaseDate: String?
    var genres: [String]
    var posterPath: String?
    var backdropPath: String?
    var tmdbID: Int
    var dateAdded: Date = Date()
    var voteAverage: Float
    
    
//    @Relationship(inverse: \Playlist.movies)
    @Relationship var playlists: [Playlist] = []
//    var playlist: Playlist?

    init(title: String, overview: String, releaseDate: String?, genres: [String], posterPath: String?, backdropPath: String?, tmdbID: Int, dateAdded: Date = Date(), voteAverage: Float) {
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
        self.genres = genres
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.tmdbID = tmdbID
        self.dateAdded = dateAdded
        self.voteAverage = voteAverage
    }
}

extension Movie: Hashable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
            lhs.tmdbID == rhs.tmdbID
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(tmdbID)
        }
    
    var genreMessage: String {
        guard let mainGenre = genres.first else {
            return "This film is perfect for any time."
        }

        let messages: [String: [String]] = [
            "Horror": [
                "Dare to watch alone? Start the horror now!",
                "Brace yourself for a long, spooky night! Watch now!",
                "Nightmares begin here. Lets watch!"
            ],
            "Comedy": [
                "Need a mood boost? Watch this comedy now!",
                "Laugh your day away! Watch Now!",
                "Get ready for non-stop laughs! Start now!"
            ],
            "Action": [
                "Action starts now! Don’t miss out!",
                "Ready for non-stop action? Watch now!",
                "The chase begins! Join the action now!"
            ],
            "Romance": [
                "Get ready for heartwarming love! Watch now!",
                "Prepare to fall in love. Watch now!",
                "Tissues ready? This romance will melt your heart!"
            ],
            "Thriller": [
                "Ready for the twist? Watch now!",
                "Can you guess the culprit? Watch to find out!",
                "Every second counts! Don’t miss a thing!"
            ],
            "Drama": [
                "Feel the emotion. Watch this dramatic journey!",
                "A story that stays with you. Watch now!",
                "Get ready for a powerful emotional ride!"
            ],
            "Family": [
                "Perfect for family movie time! Watch together!",
                "Fun for all ages! Start the family movie now!",
                "Gather the family! This heartwarming film awaits!"
            ],
            "Mystery": [
                "Ready to uncover hidden secrets? Watch now!",
                "Everyone’s a suspect! Watch to solve the mystery!",
                "Eyes wide open! Every detail is a clue!"
            ],
            "Science Fiction": [
                "Prepare for a mind-blowing experience! Watch now!",
                "Discover futuristic tech in this must-see sci-fi!",
                "The future awaits! Watch this sci-fi adventure now!"
            ],
            "Crime": [
                "Solve the crime that no one saw coming!",
                "Uncover the crime mystery. Watch now!",
                "Ready to crack the case? Watch Now!"
            ],
            "Adventure": [
                    "Start your adventure now!",
                    "Join the journey today!",
                    "Epic adventure awaits!"
                ],
                "Animation": [
                    "Watch this colorful animation!",
                    "Fun for all ages, watch now!",
                    "Enjoy the animated magic!"
                ],
                "Documentary": [
                    "Learn something new now!",
                    "Discover real stories!",
                    "Explore the world through docs!"
                ],
                "Fantasy": [
                    "Enter a magical world!",
                    "A fantasy adventure awaits!",
                    "Step into the unknown!"
                ],
                "History": [
                    "Relive the past now!",
                    "Watch history unfold!",
                    "Experience the past today!"
                ],
                "TV Movie": [
                    "Perfect movie for TV time!",
                    "Enjoy this TV movie now!",
                    "Watch a great TV movie!"
                ],
                "War": [
                    "Feel the intensity of war!",
                    "Watch the battle unfold!",
                    "Experience the war today!"
                ],
                "Western": [
                    "Ride into the wild west!",
                    "Saddle up for a western!",
                    "Watch a thrilling western!"
                ],
                "Music": [
                    "Feel the rhythm of music!",
                    "Sing along with this musical!",
                    "Enjoy a musical masterpiece!"
                ]
        ]

        let defaultMessages = ["This film is perfect for any time."]

        return messages[mainGenre]?.randomElement() ?? defaultMessages.randomElement()!
    }
    
    var releaseYearEra: String {
        guard let releaseDate = releaseDate, let year = Int(releaseDate.prefix(4)) else {
            return "Unknown"
        }
        
        switch year {
        case ..<2000:
            return "Vintage < 2000"
        case 2000...2011:
            return "Gen Z 2000 – 2011"
        case 2012...2024:
            return "Gen A 2012 - 2024"
        case 2025...:
            return "Latest > 2024"
        default:
            return "Unknown"
        }
    }
}




//@Model
//class Movie {
//    @Attribute(.unique) var id: String
//    var title: String
//    var overview: String
//    var releaseYear: String
//    var genre: String
//    var posterURL: String
//    
//    init(id: String, title: String, overview: String, releaseYear: String, genre: String, posterURL: String) {
//        self.id = id
//        self.title = title
//        self.overview = overview
//        self.releaseYear = releaseYear
//        self.genre = genre
//        self.posterURL = posterURL
//    }
//}
