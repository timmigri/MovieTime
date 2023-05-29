//
//  BookmarkViewModel.swift
//  MovieTime
//
//  Created by Артём Грищенко on 28.05.2023.
//

import Foundation

class BookmarkViewModel: ObservableObject {
    @Published private(set) var movieList: [MovieDetailModel] = []
    @Published var query: String = ""
    @Published var showResults = true
    @Injected var bookmarkService: BookmarkMovieService

    func getMovieListFromDB() {
        let (res, totalCount) = bookmarkService.getMoviesList(query: query)
        movieList = res
        showResults = totalCount > 0
    }

    func onChangeSearchOptions() {
        getMovieListFromDB()
    }
}
