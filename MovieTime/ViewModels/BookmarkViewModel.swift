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
    @Published private(set) var movieList: [MovieDetailModel] = []
    @Published var query: String = ""
    @Published var showResults = true
    @Published var sortOptions = [
        CustomSelect.SelectOption(title: R.string.favorite.sortOptionName(), key: "name"),
        CustomSelect.SelectOption(title: R.string.favorite.sortOptionYear(), key: "year"),
        CustomSelect.SelectOption(title: R.string.favorite.sortOptionRating(), key: "rating")
    ]
    @Published var sortOrderAscending = false
    @Injected var bookmarkService: BookmarkMovieService

    var currentSortOptionIndex: Int? {
        if let index = sortOptions.firstIndex(where: { $0.isSelected }) {
            return index
        }
        return nil
    }

    var currentSortOptionKey: String? {
        if let index = currentSortOptionIndex { return sortOptions[index].key }
        return nil
    }

    func getMovieListFromDB() {
        let (res, totalCount) = bookmarkService.getMoviesList(query: query, sortKey: currentSortOptionKey, ascending: sortOrderAscending)
        movieList = res
        showResults = totalCount > 0
    }

    func onChangeSearchOptions() {
        getMovieListFromDB()
    }

    func onSelectSortOption(_ index: Int, _ key: String) {
        withAnimation(.easeInOut(duration: 0.2)) {
            if !sortOptions[index].isSelected {
                for ind in sortOptions.indices { sortOptions[ind].isSelected = false }
            }
            sortOptions[index].isSelected.toggle()
        }
        onChangeSearchOptions()
    }
    
    func onTapSortOrderButton() {
        withAnimation(.easeInOut(duration: 0.2)) {
            sortOrderAscending.toggle()
            onChangeSearchOptions()
        }
    }
}
