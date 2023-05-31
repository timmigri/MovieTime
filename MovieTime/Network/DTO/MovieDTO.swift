//
//  MovieDTO.swift
//  MovieTime
//
//  Created by Артём Грищенко on 30.05.2023.
//

import Foundation

struct MovieListDTO: PaginationDTO {
    let docs: [MovieDTO]
    let pages: Int
    let page: Int

    static let empty = MovieListDTO(docs: [], pages: 0, page: 0)
}

struct MovieDTO: DTO {
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

struct MovieDetailDTO: DTO {
    let id: Int
    let name: String?
    let year: Int?
    let movieLength: Int?
    let seriesLength: Int?
    let seasonsInfo: [SeasonInfo]?
    let description: String?
    let facts: [Fact]?
    let genres: [Genre]?
    let rating: MovieDTO.Rating?
    let poster: MovieDTO.Poster?
    let persons: [MoviePersonDTO]?

    struct Fact: Decodable {
        let value: String
        let spoiler: Bool
    }

    struct Genre: Decodable {
        let name: String
    }

    struct SeasonInfo: Decodable {
        let number: Int
        let episodesCount: Int
    }

}

struct MoviePersonDTO: DTO {
    let id: Int
    let name: String?
    let photo: String?
    let profession: String?
}
