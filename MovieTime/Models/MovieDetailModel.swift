//
//  MovieDetailModel.swift
//  MovieTime
//
//  Created by Артём Грищенко on 15.05.2023.
//

import Foundation

class MovieDetailModel: MovieModel {
    let seriesLength: Int?
    let seriesSeasonsCount: Int?
    let description: String?
    let facts: [String]
    let genres: [String]
    let actors: [PersonModel]

    init(id: Int,
         name: String,
         year: Int?,
         movieLength: Int?,
         seriesLength: Int?,
         seriesSeasonsCount: Int?,
         description: String?,
         facts: [String],
         genres: [String],
         posterUrl: String?,
         rating: Float,
         actors: [PersonModel],
         posterImage: Data? = nil) {
            self.seriesLength = seriesLength
            self.seriesSeasonsCount = seriesSeasonsCount
            self.description = description
            self.facts = facts
            self.genres = genres
            self.actors = actors
            super.init(
                id: id,
                year: year,
                movieLength: movieLength,
                name: name,
                posterUrl: posterUrl,
                rating: rating,
                posterImage: posterImage
            )
    }
}
