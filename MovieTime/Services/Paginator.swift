//
//  Paginator.swift
//  MovieTime
//
//  Created by Артём Грищенко on 14.05.2023.
//

import Foundation

class Paginator {
    enum Key {
        case movieList
        case actorList
    }
    
    init() {
        paginatorMap[.movieList] = (0, nil)
        paginatorMap[.actorList] = (0, nil)
    }
    
    private var paginatorMap = [Key:(page: Int, pages: Int?)]()
    
    func setPage(forKey: Key, page: Int, pages: Int) {
        paginatorMap[forKey]!.page = max(paginatorMap[forKey]!.page, page)
        paginatorMap[forKey]!.pages = pages
    }

    func getNextPage(forKey: Key) -> Int? {
        let (page, pages) = paginatorMap[forKey]!
        if (pages == nil) { return 1 }
        if (page < pages!) { return page + 1 }
        return nil
    }
    
    func reset(forKey: Key) {
        paginatorMap[forKey] = (0, nil)
    }
}
