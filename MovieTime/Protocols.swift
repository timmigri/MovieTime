//
//  Protocols.swift
//  MovieTime
//
//  Created by Артём Грищенко on 30.05.2023.
//

import Foundation
import Moya

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
