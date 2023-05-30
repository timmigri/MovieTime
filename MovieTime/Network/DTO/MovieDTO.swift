//
//  MovieDTO.swift
//  MovieTime
//
//  Created by Артём Грищенко on 30.05.2023.
//

import Foundation

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

struct MovieListDTO: PaginationDTO {
    let docs: [MovieDTO]
    let pages: Int
    let page: Int
    
    static let empty = MovieListDTO(docs: [], pages: 0, page: 0)
}

