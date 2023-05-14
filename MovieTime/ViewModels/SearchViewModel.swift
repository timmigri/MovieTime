//
//  SearchViewModel.swift
//  MovieTime
//
//  Created by Артём Грищенко on 12.05.2023.
//

import Foundation
import SwiftUI

class SearchViewModel: ObservableObject {
    let sortOptions = [("Title", "name"), ("Year", "year"), ("Rating", "rating.kp")]
    private let maxFilterCategories = 3
    @Injected var networkManager: NetworkManager
    @Injected var paginator: Paginator
    @Published var currentSortOptionIndex: Int?
    @Published var filterCategories = FilterCategory.generateCategories()
    @Published var isLoadingMovies = false
    @Published var movies: [MovieModel] = []
    @Published var query: String = ""

    // Sort option
    func onChooseSortOption(_ index: Int) {
        if currentSortOptionIndex != nil && currentSortOptionIndex! == index {
            currentSortOptionIndex = nil
        } else {
            currentSortOptionIndex = index
        }
    }

    func isSortOptionActive(_ index: Int) -> Bool {
        return currentSortOptionIndex != nil && currentSortOptionIndex! == index
    }

    var showFilterResultsButton: Bool {
        currentSortOptionIndex != nil || countChoosedFilterCategories > 0
    }

    // Filter categories
    func onChooseFilterCategory(_ id: String) {
        if let index = filterCategories.firstIndex(where: { $0.id == id }) {
            if (!canChooseFilterCategory(filterCategories[index].isChoosed)) { return }
            filterCategories[index].isChoosed.toggle()
        }
    }
    
    func resetFilterCategories() {
        for index in filterCategories.indices {
            filterCategories[index].isChoosed = false
        }
    }

    func canChooseFilterCategory(_ isChoosed: Bool) -> Bool {
        return isChoosed || countChoosedFilterCategories < maxFilterCategories
    }

    var countChoosedFilterCategories: Int {
        filterCategories.filter { $0.isChoosed }.count
    }

    // API
    func onChangeSearchOptions() {
        if isLoadingMovies || query.count == 0 { return }
        movies = []
        isLoadingMovies = true
        let sortField = currentSortOptionIndex != nil ? sortOptions[currentSortOptionIndex!].1 : nil
        let genres = filterCategories.filter { $0.isChoosed }.map { $0.searchKey }
        networkManager.loadMovies(query: query, sortField: sortField, genres: genres) { (_, res) in
            self.movies += res
            DispatchQueue.main.async {
                print(self.paginator.value)
                self.isLoadingMovies = false
            }
        }
    }
}
