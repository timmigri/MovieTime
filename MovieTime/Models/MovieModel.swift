//
//  MovieDataModel.swift
//  MovieTime
//
//  Created by Артём Грищенко on 13.05.2023.
//

import Foundation

struct MovieModel: Identifiable {
    let id: Int
    let year: Int?
    let movieLength: Int?
    let name: String
    let posterUrl: String
    let rating: Float

    private init(rawData: RawMovieModel) {
        self.id = rawData.id
        self.name = rawData.name!
        self.posterUrl = rawData.poster!.previewUrl
        self.rating = rawData.rating!.kp
        self.movieLength = rawData.movieLength
        self.year = rawData.year
    }

    static func processRawData(_ rawData: RawMoviesResultModel) -> [MovieModel] {
        var movies = [MovieModel]()
        for rawMovie in rawData.docs {
            if rawMovie.name == nil { continue }
            if rawMovie.poster == nil { continue }
            if rawMovie.rating == nil { continue }
            movies.append(MovieModel(rawData: rawMovie))
        }
        return movies
    }

    var durationString: String? {
        if let movieLength {
            let hoursString = movieLength >= 60 ? String(movieLength / 60) + " ч " : ""
            let minutesString = String(movieLength % 60) + " м"
            return hoursString + minutesString
        }
        return year != nil ? String(year!) + " г" : nil
    }

    var formattedRatingString: String {
        String(format: "%.1f", rating)
    }
}

struct RawMovieModel: Decodable {
    let id: Int
    let year: Int?
    let name: String?
    let movieLength: Int?
    let rating: Rating?
    let poster: Poster?

    struct Poster: Decodable {
        let previewUrl: String
    }

    struct Rating: Decodable {
        let kp: Float // swiftlint:disable:this identifier_name
    }
}

struct RawMoviesResultModel: Decodable {
    let docs: [RawMovieModel]
    let pages: Int
    let page: Int
}
