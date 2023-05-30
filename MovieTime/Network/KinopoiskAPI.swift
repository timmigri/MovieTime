//
//  KinopoiskAPI.swift
//  MovieTime
//
//  Created by Артём Грищенко on 29.05.2023.
//

import Moya

enum KinopoiskAPI {
    case persons(query: String, page: Int)
    case movies(query: String, page: Int, sortField: String?, genres: [String])
}

extension KinopoiskAPI: TargetType, Hashable {
    var baseURL: URL {
        guard let url = URL(string: "https://api.kinopoisk.dev/") else { fatalError() }
        return url
    }

    var path: String {
        switch self {
        case .persons:
            return "v1.2/person/search"
        case .movies:
            return "v1.3/movie"
        }
    }

    var method: Method {
        return .get
    }

    var task: Task {
        switch self {
        case let .persons(query, page):
            return .requestParameters(parameters: [
                "query": query,
                "page": page,
                "limit": AppConstants.basicPageSize
            ], encoding: URLEncoding.queryString)
        case let .movies(query, page, sortField, genres):
            var parameters: [String : Any] = [
                "name": query,
                "page": page,
                "limit": AppConstants.basicPageSize,
            ]
            for type in 1...6 {
                parameters["typeNumber"] = String(type)
            }
            if let sortField {
                parameters["sortField"] = sortField
            }
            for genre in genres {
                parameters["genres.name"] = genre
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }

    var headers: [String: String]? {
        return [
            "accept": "application/json",
            "X-API-KEY": AppConfig.apiKey
        ]
    }
    
    var sampleData: Data {
        return Data()
    }
}
