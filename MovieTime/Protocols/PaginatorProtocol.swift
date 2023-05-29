//
//  PaginatorProtocol.swift
//  MovieTime
//
//  Created by Артём Грищенко on 29.05.2023.
//

import Foundation

protocol PaginatorProtocol {
    associatedtype Key where Key: Hashable

    func setPage(forKey: Key, page: Int)
    func setTotalPages(forKey: Key, pages: Int)
    func getNextPage(forKey: Key) -> Int?
    func reset(forKey: Key)
}
