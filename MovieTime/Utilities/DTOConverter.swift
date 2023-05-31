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
            photoUrl: dto.photo
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

        var persons = [PersonModel]()
        if let dtoPersons = dto.persons {
            for person in dtoPersons {
                guard let profession = person.profession else { continue }
                if profession != "актеры" { continue }
                guard let personModel = convert(PersonDTO(
                    id: person.id,
                    name: person.name,
                    photo: person.photo
                )) else { continue }
                persons.append(personModel)
            }
        }

        return MovieDetailModel(
            id: dto.id,
            name: name,
            year: dto.year,
            movieLength: dto.movieLength,
            seriesLength: dto.seriesLength,
            seriesSeasonsCount: dto.seasonsInfo?.count,
            description: dto.description,
            facts: facts,
            genres: genres.map { $0.name },
            posterUrl: poster.previewUrl,
            rating: rating.kp,
            actors: persons
        )
    }
}
