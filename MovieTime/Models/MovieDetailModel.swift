//
//  MovieDetailModel.swift
//  MovieTime
//
//  Created by Артём Грищенко on 15.05.2023.
//

import Foundation

struct MovieDetailModel: Identifiable {
    let id: Int
    let name: String
    let year: Int
    let movieLength: Int
    let description: String
    let facts: [String]?
    let genres: [String]
    let posterUrl: String
    let rating: Float
    let actors: [ActorModel]

    private init(rawData: RawMovieDetailModel) {
        self.id = rawData.id
        self.name = rawData.name!
        self.year = rawData.year!
        self.movieLength = rawData.movieLength!
        self.description = rawData.description!
        self.facts = Array(rawData.facts?.filter { !$0.spoiler && !$0.value.contains("<a href") }.map{ $0.value }.prefix(5) ?? [])
        self.genres = rawData.genres!.map { $0.name }
        self.posterUrl = rawData.poster!.previewUrl
        self.rating = rawData.rating!.kp
        self.actors = rawData.persons!.filter { $0.profession == "актеры" && $0.name != nil }.map {
            ActorModel(id: $0.id, name: $0.name!, photo: $0.photo)
        }
    }

    static func processRawData(_ rawMovie: RawMovieDetailModel) -> MovieDetailModel? {
        if rawMovie.name == nil { return nil }
        if rawMovie.year == nil { return nil }
        if rawMovie.movieLength == nil { return nil }
        if rawMovie.description == nil { return nil }
        if rawMovie.genres == nil { return nil }
        if rawMovie.poster == nil { return nil }
        if rawMovie.rating == nil { return nil }
        if rawMovie.persons == nil { return nil }

        return MovieDetailModel(rawData: rawMovie)
    }

    var durationString: String {
        let hoursString = movieLength >= 60 ? String(movieLength / 60) + "ч " : ""
        let minutesString = String(movieLength % 60) + "м"
        return hoursString + minutesString
    }

    var formattedRatingString: String {
        String(format: "%.1f", rating)
    }
    
    var genresString: String {
        genres.prefix(3).joined(separator: ", ")
    }
}

struct RawMovieDetailModel: Decodable {
    let id: Int
    let name: String?
    let year: Int?
    let movieLength: Int?
    let description: String?
    let facts: [Fact]?
    let genres: [Genre]?
    let rating: Rating?
    let poster: Poster?
    let persons: [Person]?

    struct Poster: Decodable {
        let previewUrl: String
    }

    struct Rating: Decodable {
        let kp: Float
    }
    
    struct Person: Decodable {
        let id: Int
        let name: String?
        let photo: String?
        let profession: String?
    }

    struct Fact: Decodable {
        let value: String
        let spoiler: Bool
    }

    struct Genre: Decodable {
        let name: String
    }
}
