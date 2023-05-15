//
//  NetworkManager.swift
//  MovieTime
//
//  Created by Артём Грищенко on 13.05.2023.
//

import Foundation

class NetworkManager {
    @Injected var paginator: Paginator
    let baseUrl = "https://api.kinopoisk.dev"
    let apiKey = "EHFMXJT-TQN4X5B-GT5DC5N-GJWM6CV"
    let decoder = JSONDecoder()

    func loadMovies(query: String, sortField: String?, genres: [String],  completion: @escaping (Int, [MovieModel]) -> Void) {
        let nextPage = paginator.getNextPage(forKey: .movieList)
        if nextPage == nil { return }
        var components = URLComponents(string: baseUrl + "/v1.3/movie")!
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "page", value: String(nextPage!)))
        queryItems.append(URLQueryItem(name: "limit", value: "10"))
        queryItems.append(URLQueryItem(name: "alternativeName", value: query))
        if let sortField {
            queryItems.append(URLQueryItem(name: "sortField", value: sortField))
        }
        for genre in genres {
            queryItems.append(URLQueryItem(name: "genres.name", value: genre))
        }
        components.queryItems = queryItems
        let requestUrl = components.url
        if requestUrl == nil { return }
        var request = URLRequest(url: requestUrl!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue(apiKey, forHTTPHeaderField: "X-API-KEY")
        print(requestUrl)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else { return }

            let json = String(data: data, encoding: String.Encoding.utf8)
            print("Failure Response: \(json)")

            do {
                let moviesData = try self.decoder.decode(RawMoviesDataModel.self, from: data)
                var statusCode = 400
                if let httpResponse = response as? HTTPURLResponse {
                    statusCode = httpResponse.statusCode
                }
                print("\(moviesData.page)/\(moviesData.pages)")
                self.paginator.setPage(forKey: .movieList, page: moviesData.page, pages: moviesData.pages)
                completion(statusCode, MovieModel.processRawData(moviesData))
            } catch {
                print("\(error)")
            }
        }
        task.resume()
    }
}
