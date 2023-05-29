//
//  NetworkPaginator.swift
//  MovieTime
//
//  Created by Артём Грищенко on 29.05.2023.
//

import Foundation

class NetworkPaginator: PaginatorProtocol {
    typealias Value = (page: Int, pages: Int?)
    enum Key {
        case personList
    }

    private var paginatorMap = [Key: Value]()

    func setPage(forKey: Key, page: Int) {
        guard var value = paginatorMap[forKey] else { return }
        value.page = max(value.page, page)
        paginatorMap.updateValue(value, forKey: forKey)
    }

    func setTotalPages(forKey: Key, pages: Int) {
        guard var value = paginatorMap[forKey] else { return }
        value.pages = pages
        paginatorMap.updateValue(value, forKey: forKey)
    }

    func getNextPage(forKey: Key) -> Int? {
        guard let value = paginatorMap[forKey] else {
            reset(forKey: forKey)
            return 1
        }

        let (page, pages) = value
        if pages == nil { return 1 }
        if page < pages! { return page + 1 }
        return nil
    }

    func reset(forKey: Key) {
        paginatorMap[forKey] = (0, nil)
    }
}

extension NetworkPaginator {
    static func getKeyByRequestType(requestType: KinopoiskAPI) -> Key{
        switch requestType {
        case .persons(_, _):
            return .personList
        }
    }
}
