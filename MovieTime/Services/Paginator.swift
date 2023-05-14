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
    }
    
    init() {
        paginatorMap[.movieList] = (0, nil)
    }
    
    private var paginatorMap = [Key:(page: Int, pages: Int?)]()
    
    func setPage(forKey: Key, page: Int, pages: Int) {
        paginatorMap[forKey]!.page = max(paginatorMap[forKey]!.page, page)
        paginatorMap[forKey]!.pages = pages
    }

    func canGoNextPage(forKey: Key) -> Bool {
        let (page, pages) = paginatorMap[forKey]!
        return pages == nil || page < pages!
    }
    
    func reset(forKey: Key) {
        paginatorMap[forKey] = (0, nil)
    }
}
