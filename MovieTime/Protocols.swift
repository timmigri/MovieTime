//
//  Protocols.swift
//  MovieTime
//
//  Created by Артём Грищенко on 30.05.2023.
//

import Foundation
import Moya
import RealmSwift

// MARK: Common protocols
protocol PaginatorProtocol {
    associatedtype Key where Key: Hashable

    func setPage(forKey: Key, page: Int)
    func setTotalPages(forKey: Key, pages: Int)
    func getNextPage(forKey: Key) -> Int?
    func reset(forKey: Key)
}

// MARK: Network protocols
protocol DTO: Decodable {

}

protocol PaginationDTO: Decodable {
    associatedtype Item where Item: DTO

    var page: Int { get }
    var pages: Int { get }
    var docs: [Item] { get }
}

protocol NetworkableProtocol {
    var provider: MoyaProvider<KinopoiskAPI> { get }
    func fetchPersons(_ query: String, completion: @escaping (Result<PersonListDTO, Error>) -> Void)
}

// MARK: Database protocols
protocol MovieRepositoryProtocol {
    func getMovie(kpId: Int?, uuid: UUID?) -> MovieEntity?
    func containsMovie(kpId: Int?, uuid: UUID?) -> Bool
    // MARK: return true if movie was created after calling this method
    func toggleMovie(movie: MovieDetailModel) -> Bool?
    func getAllMovies() -> Results<MovieEntity>?
    func applyFilters(
        _ results: Results<MovieEntity>,
        query: String,
        sortKey: String?,
        ascending: Bool
    ) -> Results<MovieEntity>
    func createBasicGenres()
}

protocol MovieRatingRepositoryProtocol {
    func getRating(forId id: Int) -> Int
    func setRating(forId id: Int, value: Int)
}

// Services
protocol ShareServiceProtocol {
    static func shareMovie(_ movie: MovieModel, source: UIViewController)
}
