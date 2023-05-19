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
    private let minLengthOfQueryToSearch = 3
    @Injected var networkManager: NetworkManager
    @Injected var paginator: Paginator
    @Published var currentSortOptionIndex: Int?
    @Published var filterCategories = FilterCategoryModel.generateCategories()
    @Published var isLoadingMovies = false
    @Published var isLoadingActors = false
    @Published var movies = [MovieModel]()
    @Published var actors = [PersonModel]()
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
            if !canChooseFilterCategory(filterCategories[index]) { return }
            filterCategories[index].isChoosed.toggle()
        }
    }

    func resetFilterCategories() {
        for index in filterCategories.indices {
            filterCategories[index].isChoosed = false
        }
    }

    func canChooseFilterCategory(_ category: FilterCategoryModel) -> Bool {
        return category.isChoosed || countChoosedFilterCategories < maxFilterCategories
    }

    var countChoosedFilterCategories: Int {
        filterCategories.filter { $0.isChoosed }.count
    }

    var showMoviesSection: Bool {
        return movies.count > 0 || isLoadingMovies
    }

    var showActorsSection: Bool {
        return actors.count > 0 || isLoadingActors
    }

    var showNoResultPicture: Bool {
        if showMoviesSection || showActorsSection { return false }
        return query.count >= minLengthOfQueryToSearch
    }

    var showSearchPicture: Bool {
        if showMoviesSection || showActorsSection { return false }
        return query.count < minLengthOfQueryToSearch
    }

    // API
    func onChangeSearchOptions() {
        movies = []
        actors = []
        paginator.reset(forKey: .movieList)
        paginator.reset(forKey: .actorList)
        loadMovies()
        loadActors()
    }

    func loadMovies() {
        if isLoadingMovies || query.count < minLengthOfQueryToSearch { return }
        isLoadingMovies = true
        let sortField = currentSortOptionIndex != nil ? sortOptions[currentSortOptionIndex!].1 : nil
        let genres = filterCategories.filter { $0.isChoosed }.map { $0.searchKey }
        // TODO: error handling
        networkManager.loadMovies(query: query.lowercased(), sortField: sortField, genres: genres) { (res) in
            DispatchQueue.main.async {
                self.movies += res
                self.isLoadingMovies = false
            }
        }
    }

    func loadActors() {
        if isLoadingActors || query.count < minLengthOfQueryToSearch { return }
        isLoadingActors = true
        networkManager.loadActors(query: query.lowercased()) { (_, res) in
            DispatchQueue.main.async {
                self.actors += res
                self.isLoadingActors = false
            }
        }
    }
}
