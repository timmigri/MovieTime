//
//  MovieDataModel.swift
//  MovieTime
//
//  Created by Артём Грищенко on 13.05.2023.
//

import Foundation

struct MovieModel: Identifiable {
    let id: Int
    let name: String
    let year: Int
    let posterUrl: String
    let rating: Float

    private init(rawData: RawMovieDataModel) {
        self.id = rawData.id
        self.name = rawData.name!
        self.year = rawData.year!
        self.posterUrl = rawData.poster!["previewUrl"]!
        self.rating = rawData.rating!["kp"]! ?? 0
    }
    
    static func processRawData(_ rawData: RawMoviesDataModel) -> [MovieModel] {
        var movies = [MovieModel]()
        for rawMovie in rawData.docs {
            if rawMovie.name == nil { continue }
            if rawMovie.year == nil { continue }
            if rawMovie.poster == nil { continue }
            if rawMovie.rating == nil { continue }
            movies.append(MovieModel(rawData: rawMovie))
        }
        return movies
    }
}

struct RawMovieDataModel: Decodable {
    let id: Int
    let name: String?
    let year: Int?
    let movieLength: Int?
    let poster: [String: String]?
    let rating: [String: Float?]?
}

struct RawMoviesDataModel: Decodable {
    let docs: [RawMovieDataModel]
    let pages: Int
    let page: Int
}
