//
//  NetworkManager.swift
//  MovieTime
//
//  Created by Артём Грищенко on 13.05.2023.
//

import Moya

class NetworkManager: NetworkableProtocol {
    var provider = MoyaProvider<KinopoiskAPI>()
    @AuthInjected var networkPaginator: NetworkPaginator

    func fetchMovie(id: Int?, completion: @escaping (Result<MovieDetailDTO, Error>) -> Void) {
        request(target: .movieDetail(id: id), completion: completion)
    }

    func fetchMovies(
        query: String,
        sortField: String?,
        genres: [String],
        completion: @escaping (Result<MovieListDTO, Error>) -> Void
    ) {
        guard let page = networkPaginator.getNextPage(forKey: .movieList) else {
            completion(.success(.empty))
            return
        }
        requestWithPagination(
            target: .movies(query: query, page: page, sortField: sortField, genres: genres),
            completion: completion
        )
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

    private func requestWithPagination<T: PaginationDTO>(
        target: KinopoiskAPI,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
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
