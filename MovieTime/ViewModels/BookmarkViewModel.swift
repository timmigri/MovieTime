//
//  BookmarkViewModel.swift
//  MovieTime
//
//  Created by Артём Грищенко on 28.05.2023.
//

import Foundation

class BookmarkViewModel: ObservableObject {
    @Published var movieList: [MovieDetailModel] = []
    @Injected var bookmarkService: BookmarkMovieService

    func getMovieListFromDB() {
        movieList = bookmarkService.getMoviesList()
        print(movieList)
    }
}
