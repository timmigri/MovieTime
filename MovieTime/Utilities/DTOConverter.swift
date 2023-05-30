//
//  DTOConverter.swift
//  MovieTime
//
//  Created by Артём Грищенко on 30.05.2023.
//

import Foundation

class DTOConverter {
    private static func convert(_ dto: PersonDTO) -> PersonModel? {
        guard let name = dto.name else { return nil }
        if name.count == 0 { return nil }
        return PersonModel(
            id: dto.id,
            name: name,
            photo: dto.photo
        )
    }
    
    static func convert(_ dto: PersonListDTO) -> [PersonModel] {
        var persons = [PersonModel]()
        for person in dto.docs {
            guard let model = convert(person) else { continue }
            persons.append(model)
        }
        return persons
    }
    
    static func convert(_ dto: MovieListDTO) -> [MovieModel] {
        var movies = [MovieModel]()
        for movie in dto.docs {
            guard let name = movie.name else { continue }
            guard let poster = movie.poster else { continue }
            guard let rating = movie.rating else { continue }
            movies.append(MovieModel(
                id: movie.id,
                year: movie.year,
                movieLength: movie.movieLength,
                name: name,
                posterUrl: poster.previewUrl,
                rating: rating.kp,
                posterImage: nil
            ))
        }
        return movies
    }
    
    static func convert(_ dto: MovieDetailDTO) -> MovieDetailModel? {
        guard let name = dto.name else { return nil }
        guard let poster = dto.poster else { return nil }
        guard let rating = dto.rating else { return nil }
        guard let genres = dto.genres else { return nil }
        let facts = Array(
            dto.facts?
                .filter { !$0.spoiler && !$0.value.contains("<a href") }
                .map { $0.value }.prefix(5)
            ?? []
        )
        let persons = dto.persons!
            .filter { $0.profession == "актеры" }
            .compactMap { convert($0) }
        
        return MovieDetailModel(
            id: dto.id,
            name: name,
            year: dto.year,
            movieLength: dto.movieLength,
            description: dto.description,
            facts: facts,
            genres: genres.map { $0.name },
            posterUrl: poster.previewUrl,
            rating: rating.kp,
            actors: persons
        )
    }
}
