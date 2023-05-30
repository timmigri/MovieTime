//
//  MovieDetailModel.swift
//  MovieTime
//
//  Created by Артём Грищенко on 15.05.2023.
//

import Foundation

class MovieDetailModel: MovieModel {
    let description: String?
    let facts: [String]
    let genres: [String]
    let actors: [PersonModel]

    init(id: Int,
         name: String,
         year: Int?,
         movieLength: Int?,
         description: String?,
         facts: [String],
         genres: [String],
         posterUrl: String?,
         rating: Float,
         actors: [PersonModel],
         posterImage: Data? = nil) {
            self.description = description
            self.facts = facts
            self.genres = genres
            self.actors = actors
            super.init(id: id, year: year, movieLength: movieLength, name: name, posterUrl: posterUrl, rating: rating, posterImage: posterImage)
    }

    init(dbModel: MovieDBModel) {
        self.description = dbModel.movieDescription
        self.genres = []
        self.facts = []
        self.actors = []
        super.init(id: dbModel.kpId, year: dbModel.year, movieLength: dbModel.movieLength, name: dbModel.name, posterUrl: nil, rating: dbModel.rating, posterImage: dbModel.image)
    }

    static func processDbData(_ dbModel: MovieDBModel) -> MovieDetailModel {
        return MovieDetailModel(dbModel: dbModel)
    }

    var genresString: String {
        genres.prefix(3).joined(separator: ", ")
    }
}
