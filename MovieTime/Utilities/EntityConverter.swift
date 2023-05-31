//
//  EntityConverter.swift
//  MovieTime
//
//  Created by Артём Грищенко on 31.05.2023.
//

import Foundation
import RealmSwift

// MARK: convert from - from entity to model, convert to - from model to entity
class EntityConverter {
    static func convertFrom(_ results: Results<MovieEntity>) -> [MovieModel] {
        Array(results).map { movieEntity in
            convertFrom(movieEntity) as MovieModel
        }
    }

    static func convertFrom(_ movieEntity: MovieEntity) -> MovieDetailModel {
        MovieDetailModel(
            id: movieEntity.kpId,
            name: movieEntity.name,
            year: movieEntity.year,
            movieLength: movieEntity.movieLength,
            seriesLength: movieEntity.seriesLength,
            seriesSeasonsCount: movieEntity.seriesSeasonsCount,
            description: movieEntity.movieDescription,
            facts: [],
            genres: [],
            posterUrl: nil,
            rating: movieEntity.rating,
            actors: [],
            posterImage: movieEntity.image
        )
    }

    static func convertTo(_ movie: MovieDetailModel) -> MovieEntity {
        let movieEntity = MovieEntity()
        movieEntity.kpId = movie.id
        movieEntity.name = movie.name
        movieEntity.year = movie.year
        movieEntity.movieLength = movie.movieLength
        movieEntity.seriesLength = movie.seriesLength
        movieEntity.seriesSeasonsCount = movie.seriesSeasonsCount
        movieEntity.movieDescription = movie.description
        movieEntity.rating = movie.rating
        movieEntity.image = movie.posterImage
        return movieEntity
    }
}
