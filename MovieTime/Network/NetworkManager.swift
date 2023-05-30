//
//  NetworkManager.swift
//  MovieTime
//
//  Created by Артём Грищенко on 13.05.2023.
//

import Moya

class NetworkManager: NetworkableProtocol {
    var provider = MoyaProvider<KinopoiskAPI>(plugins: [NetworkLoggerPlugin()])

    @Injected var paginator: Paginator
    @Injected var networkPaginator: NetworkPaginator
    let baseUrl = "https://api.kinopoisk.dev"
    let decoder = JSONDecoder()

    func makeURLRequestObject(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue(AppConfig.apiKey, forHTTPHeaderField: "X-API-KEY")
        return request
    }

    // TODO: error handling
    func loadMovies(query: String, sortField: String?, genres: [String], completion: @escaping ([MovieModel]) -> Void) {
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
        queryItems.append(URLQueryItem(name: "typeNumber", value: "1"))
        queryItems.append(URLQueryItem(name: "typeNumber", value: "2"))
        queryItems.append(URLQueryItem(name: "typeNumber", value: "3"))
        queryItems.append(URLQueryItem(name: "typeNumber", value: "4"))
        queryItems.append(URLQueryItem(name: "typeNumber", value: "5"))
        queryItems.append(URLQueryItem(name: "typeNumber", value: "6"))
        if let sortField {
            queryItems.append(URLQueryItem(name: "sortField", value: sortField))
        }
        for genre in genres {
            queryItems.append(URLQueryItem(name: "genres.name", value: genre))
        }
        components.queryItems = queryItems

        let request = makeURLRequestObject(url: components.url!)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data else {
                completion([])
                return
            }

            do {
                let moviesData = try self.decoder.decode(RawMoviesResultModel.self, from: data)
                self.paginator.setPage(forKey: .movieList, page: moviesData.page, pages: moviesData.pages)
                completion(MovieModel.processRawData(moviesData))
            } catch {
                print("\(error)")
            }
        }
        task.resume()
    }

    func loadMovie(id: Int?, completion: @escaping (MovieDetailModel?) -> Void) {
        let urlId = id == nil ? "random" : String(id!)
        let url = URL(string: baseUrl + "/v1.3/movie/" + urlId)
        let request = makeURLRequestObject(url: url!)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data else {
                completion(nil)
                return
            }

            do {
                let movieDetail = try self.decoder.decode(RawMovieDetailModel.self, from: data)
                completion(MovieDetailModel.processRawData(movieDetail))
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func fetchMovies(query: String, sortField: String?, genres: [String], completion: @escaping (Result<MovieListDTO, Error>) -> Void) {
        guard let page = networkPaginator.getNextPage(forKey: .movieList) else {
            completion(.success(.empty))
            return
        }
        requestWithPagination(target: .movies(query: query, page: page, sortField: sortField, genres: genres), completion: completion)
    }

    func fetchPersons(_ query: String, completion: @escaping (Result<PersonListDTO, Error>) -> Void) {
        guard let page = networkPaginator.getNextPage(forKey: .personList) else {
            completion(.success(.empty))
            return
        }
        requestWithPagination(target: .persons(query: query, page: page), completion: completion)
    }
}

private extension NetworkManager {
    private func request<T: Decodable>(target: KinopoiskAPI, completion: @escaping (Result<T, Error>) -> Void) {
        provider.request(target) { rawResult in
            switch rawResult {
            case let .success(response):
                do {
                    let result = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    private func requestWithPagination<T: PaginationDTO>(target: KinopoiskAPI, completion: @escaping (Result<T, Error>) -> Void) {
        provider.request(target) { rawResult in
            switch rawResult {
            case let .success(response):
                do {
                    let result = try JSONDecoder().decode(T.self, from: response.data)
                    self.networkPaginator.setPage(
                        forKey: NetworkPaginator.getKeyByRequestType(requestType: target),
                        page: result.page
                    )
                    self.networkPaginator.setTotalPages(
                        forKey: NetworkPaginator.getKeyByRequestType(requestType: target),
                        pages: result.pages
                    )
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
