//
//  PersonDTO.swift
//  MovieTime
//
//  Created by Артём Грищенко on 29.05.2023.
//

import Foundation

struct PersonDTO: DTO {
    let id: Int
    let name: String?
    let photo: String?
}

struct PersonListDTO: PaginationDTO {
    let docs: [PersonDTO]
    let pages: Int
    let page: Int
    
    static let empty = PersonListDTO(docs: [], pages: 0, page: 0)
}
