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
    
    static func convertFrom(_ genreEntity: GenreEntity) -> GenreModel {
        GenreModel(name: genreEntity.name)
    }
    
    static func convertFrom(_ personEntity: PersonEntity) -> PersonModel {
        PersonModel(
            id: personEntity.kpId,
            name: personEntity.name,
            photoUrl: personEntity.photoUrl
        )
    }

    static func convertFrom(_ movieEntity: MovieEntity) -> MovieDetailModel {
        var facts = [String]()
        if let entityFacts = movieEntity.facts {
            facts = (try? JSONDecoder().decode([String].self, from: entityFacts)) ?? []
        }
        return MovieDetailModel(
            id: movieEntity.kpId,
            name: movieEntity.name,
            year: movieEntity.year,
            movieLength: movieEntity.movieLength,
            seriesLength: movieEntity.seriesLength,
            seriesSeasonsCount: movieEntity.seriesSeasonsCount,
            description: movieEntity.movieDescription,
            facts: facts,
            genres: movieEntity.genres.map { convertFrom($0) },
            posterUrl: nil,
            rating: movieEntity.rating,
            actors: movieEntity.actors.map { convertFrom($0) },
            posterImage: movieEntity.image
        )
    }

    static func convertTo(_ genre: GenreModel) -> GenreEntity {
        let genreEntity = GenreEntity()
        genreEntity.name = genre.name
        return genreEntity
    }

    static func convertTo(_ person: PersonModel) -> PersonEntity {
        let personEntity = PersonEntity()
        personEntity.kpId = person.id
        personEntity.name = person.name
        personEntity.photoUrl = person.photoUrl
        return personEntity
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
        movieEntity.facts = try? JSONEncoder().encode(movie.facts)
        // MARK: actors and genres appending to entity in repository
        return movieEntity
    }
}
