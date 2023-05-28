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
    @Published var isLoadingMovies = false
    @Injected var bookmarkService: BookmarkMovieService

    func getMovieListFromDB() {
        isLoadingMovies = true
        movieList = bookmarkService.getMoviesList(query: query)
        isLoadingMovies = false
    }

    func onChangeSearchOptions() {
        getMovieListFromDB()
    }
    
    var showNoBookmarkPicture: Bool {
        !isLoadingMovies && movieList.count == 0 && query.count == 0
    }
}
