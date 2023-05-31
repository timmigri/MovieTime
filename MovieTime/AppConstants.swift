//
//  AppConstants.swift
//  MovieTime
//
//  Created by Артём Грищенко on 29.05.2023.
//

import Foundation

struct AppConstants {
    // Network
    static let basicPageSize = 10

    // Search
    static let maxFilterCategories = 3
    static let minLengthOfQueryToSearch = 3

    // API
    static let baseApiUrl = "https://api.kinopoisk.dev/"
    static let shareUrlMovie = "https://www.kinopoisk.ru/film/" // +id
}
