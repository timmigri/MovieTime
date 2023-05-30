//
//  BookmarkViewModel.swift
//  MovieTime
//
//  Created by Артём Грищенко on 28.05.2023.
//

import Foundation
import SwiftUI
import RealmSwift

class BookmarkViewModel: ObservableObject {
    enum ScreenState {
        case success(movieList: [MovieModel])
        case noBookmarkPicture
        case error(error: String)
    }
    
    @Published var query: String = ""
    @Published var sortOptions = [
        CustomSelect.SelectOption(title: R.string.favorite.sortOptionName(), key: "name"),
        CustomSelect.SelectOption(title: R.string.favorite.sortOptionYear(), key: "year"),
        CustomSelect.SelectOption(title: R.string.favorite.sortOptionRating(), key: "rating")
    ]
    @Published var sortOrderAscending = false

    @Injected private var movieRepository: MovieRepository
    @Published var screenState: ScreenState = .success(movieList: [])

    var currentSortOptionIndex: Int? {
        return sortOptions.firstIndex(where: { $0.isSelected })
    }

    var currentSortOptionKey: String? {
        if let index = currentSortOptionIndex { return sortOptions[index].key }
        return nil
    }

    func onSelectSortOption(_ index: Int, _ key: String) {
        if !sortOptions[index].isSelected {
            for ind in sortOptions.indices { sortOptions[ind].isSelected = false }
        }
        sortOptions[index].isSelected.toggle()
        onChangeSearchOptions()
    }

    func onTapSortOrderButton() {
        sortOrderAscending.toggle()
        onChangeSearchOptions()
    }
    
    func onChangeSearchOptions() {
        if let movieResults = movieRepository.getAllMovies() {
            if movieResults.count == 0 {
                screenState = .noBookmarkPicture
                return
            }
            let movieList = EntityConverter.convertFrom(movieRepository.applyFilters(
                movieResults,
                query: query,
                sortKey: currentSortOptionKey,
                ascending: sortOrderAscending
            ))
            screenState = .success(movieList: movieList)
        } else {
            screenState = .error(error: R.string.favorite.databaseError())
        }
    }
}
