//
//  MovieDataModel.swift
//  MovieTime
//
//  Created by Артём Грищенко on 13.05.2023.
//

import Foundation

class MovieModel: Identifiable {
    let id: Int
    let year: Int?
    let movieLength: Int?
    let name: String
    let posterUrl: String?
    let rating: Float
    var posterImage: Data?

    init(
        id: Int,
        year: Int?,
        movieLength: Int?,
        name: String,
        posterUrl: String?,
        rating: Float,
        posterImage: Data? = nil) {
            self.id = id
            self.year = year
            self.movieLength = movieLength
            self.name = name
            self.posterUrl = posterUrl
            self.rating = rating
            self.posterImage = posterImage
    }
}
