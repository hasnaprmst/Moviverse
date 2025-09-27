//
//  MovieFilterHelper.swift
//  MyMovieList
//
//  Created by Hasna Paramesti Ahmad on 06/05/25.
//

//Ini Final Before Revision
import Foundation

func genresForMood(mood: String) -> [String] {
    switch mood {
    case "Nangis":
        return ["Romance", "Drama", "Family"]
    case "Ketawa":
        return ["Comedy"]
    case "Adrenalin":
        return ["Action"]
    default:
        return []
    }
}
