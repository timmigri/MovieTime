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
        GenreModel(
            name: genreEntity.name,
            pictureName: genreEntity.pictureName,
            searchKey: genreEntity.searchKey
        )
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
        var posterData: Data?
        
        var uuid: UUID? = nil
        if let uuidString = movieEntity.uuid {
            uuid = UUID(uuidString: uuidString)
        }
        
        if let kpId = movieEntity.kpId {
            posterData = DeviceImage.getImageFromLocalPath(.moviePoster(movieId: kpId))
        } else if let uuid {
            posterData = DeviceImage.getImageFromLocalPath(.customMoviePoster(movieUUID: uuid))
        }
        if let entityFacts = movieEntity.facts {
            facts = (try? JSONDecoder().decode([String].self, from: entityFacts)) ?? []
        }
        
        return MovieDetailModel(
            kpId: movieEntity.kpId,
            uuid: uuid,
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
            posterImage: posterData
        )
    }

    static func convertTo(_ genre: GenreModel) -> GenreEntity {
        let genreEntity = GenreEntity()
        genreEntity.name = genre.name
        genreEntity.pictureName = genre.pictureName
        genreEntity.searchKey = genre.searchKey
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
        movieEntity.kpId = movie.kpId
        movieEntity.uuid = movie.uuid?.uuidString
        movieEntity.name = movie.name
        movieEntity.year = movie.year
        movieEntity.movieLength = movie.movieLength
        movieEntity.seriesLength = movie.seriesLength
        movieEntity.seriesSeasonsCount = movie.seriesSeasonsCount
        movieEntity.movieDescription = movie.description
        movieEntity.rating = movie.rating
        movieEntity.facts = try? JSONEncoder().encode(movie.facts)
        // MARK: actors and genres appending to entity in repository
        return movieEntity
    }
}
