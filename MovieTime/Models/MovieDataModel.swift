//
//  MovieDataModel.swift
//  MovieTime
//
//  Created by Артём Грищенко on 13.05.2023.
//

import Foundation

struct MovieModel: Identifiable {
    let id: Int
    let movieLength: Int
    let name: String
    let posterUrl: String
    let rating: Float

    private init(rawData: RawMovieDataModel) {
        self.id = rawData.id
        self.name = rawData.name!
        self.posterUrl = rawData.poster!.previewUrl
        self.rating = rawData.rating!.kp
        self.movieLength = rawData.movieLength!
    }

    static func processRawData(_ rawData: RawMoviesDataModel) -> [MovieModel] {
        var movies = [MovieModel]()
        for rawMovie in rawData.docs {
            if rawMovie.name == nil { continue }
            if rawMovie.poster == nil { continue }
            if rawMovie.rating == nil { continue }
            if rawMovie.movieLength == nil { continue }
            movies.append(MovieModel(rawData: rawMovie))
        }
        return movies
    }

    var durationString: String {
        let hoursString = movieLength >= 60 ? String(movieLength / 60) + "ч " : ""
        let minutesString = String(movieLength % 60) + "м"
        return hoursString + minutesString
    }
    
    var formattedRatingString: String {
        String(format: "%.1f", rating)
    }
}

struct RawMovieDataModel: Decodable {
    let id: Int
    let name: String?
    let movieLength: Int?
    let rating: Rating?
    let poster: Poster?
    
    struct Poster: Decodable {
        let previewUrl: String
    }
    
    struct Rating: Decodable {
        let kp: Float
    }
}

struct RawMoviesDataModel: Decodable {
    let docs: [RawMovieDataModel]
    let pages: Int
    let page: Int
}
