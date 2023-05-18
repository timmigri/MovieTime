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

    func makeURLRequestObject(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue(apiKey, forHTTPHeaderField: "X-API-KEY")
        return request
    }

    // TODO: error handling
    func loadMovies(query: String, sortField: String?, genres: [String], completion: @escaping ([MovieModel]) -> Void) {
        print("load movies")
        let nextPage = paginator.getNextPage(forKey: .movieList)
        if nextPage == nil {
            completion([])
            return
        }

        var components = URLComponents(string: baseUrl + "/v1.3/movie")!
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "page", value: String(nextPage!)))
        queryItems.append(URLQueryItem(name: "limit", value: "10"))
        queryItems.append(URLQueryItem(name: "name", value: query))
        if let sortField {
            queryItems.append(URLQueryItem(name: "sortField", value: sortField))
        }
        for genre in genres {
            queryItems.append(URLQueryItem(name: "genres.name", value: genre))
        }
        components.queryItems = queryItems

        let request = makeURLRequestObject(url: components.url!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else {
                completion([])
                return
            }

            do {
                let moviesData = try self.decoder.decode(RawMoviesDataModel.self, from: data)
                self.paginator.setPage(forKey: .movieList, page: moviesData.page, pages: moviesData.pages)
                completion(MovieModel.processRawData(moviesData))
            } catch {
                print("\(error)")
            }
        }
        task.resume()
    }

    // TODO: error handling
    func loadMovie(id: Int, completion: @escaping (MovieDetailModel?) -> Void) {
        let url = URL(string: baseUrl + "/v1.3/movie/" + String(id))
        let request = makeURLRequestObject(url: url!)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data else { return }

            do {
                let movieDetail = try self.decoder.decode(RawMovieDetailModel.self, from: data)

                completion(MovieDetailModel.processRawData(movieDetail)!)
            } catch {
                print("\(error)")
            }
        }
        task.resume()
    }
    
    // TODO: error handling
    func loadActors(query: String, completion: @escaping (Int, [ActorModel]) -> Void) {
        print("load actors")
        let nextPage = paginator.getNextPage(forKey: .actorList)
        if nextPage == nil { return }
        var components = URLComponents(string: baseUrl + "/v1.2/person/search")!
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "page", value: String(nextPage!)))
        queryItems.append(URLQueryItem(name: "limit", value: "10"))
        queryItems.append(URLQueryItem(name: "query", value: query))
        components.queryItems = queryItems
        
        let request = makeURLRequestObject(url: components.url!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else { return }
            print(data)
            do {
                let actorsData = try self.decoder.decode(RawActorsDataModel.self, from: data)
                self.paginator.setPage(forKey: .actorList, page: actorsData.page, pages: actorsData.pages)
                completion(200, ActorModel.processRawData(actorsData.docs))
            } catch {
                print("\(error)")
            }
        }
        task.resume()
    }
}
