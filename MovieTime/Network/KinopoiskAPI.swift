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
    case movieDetail(id: Int?)
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
        case .movieDetail(let id):
            if let id {
                return "v1.3/movie/" + String(id)
            }
            return "v1.3/movie/random"
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
            var parameters: [String: Any] = [
                "name": query,
                "page": page,
                "limit": AppConstants.basicPageSize,
                "typeNumber": [1, 2, 3, 4, 5, 6]
            ]
            if let sortField {
                parameters["sortField"] = sortField
            }
            for genre in genres {
                parameters["genres.name"] = genre
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .movieDetail:
            return .requestPlain
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
