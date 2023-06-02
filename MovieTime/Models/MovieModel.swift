//
//  MovieDataModel.swift
//  MovieTime
//
//  Created by Артём Грищенко on 13.05.2023.
//

import Foundation

class MovieModel: Identifiable {
    let kpId: Int?
    let uuid: UUID?
    let year: Int?
    let movieLength: Int?
    let name: String
    let posterUrl: String?
    let rating: Float?
    var posterImage: Data?

    init(
        kpId: Int?,
        uuid: UUID?,
        year: Int?,
        movieLength: Int?,
        name: String,
        posterUrl: String?,
        rating: Float?,
        posterImage: Data? = nil) {
            self.kpId = kpId
            self.uuid = uuid
            self.year = year
            self.movieLength = movieLength
            self.name = name
            self.posterUrl = posterUrl
            self.rating = rating
            self.posterImage = posterImage
    }
}
