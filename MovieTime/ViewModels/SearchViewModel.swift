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
    @Published var filterCategories = FilterCategory.generateCategories()
    @Published var isLoadingMovies = false
    @Published var isLoadingActors = false
    @Published var movies = [MovieModel]()
    @Published var actors = [ActorModel]()
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
            if !canChooseFilterCategory(filterCategories[index].isChoosed) { return }
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

    func getFilterCategoryTextColor(_ category: FilterCategory) -> Color {
        canChooseFilterCategory(category.isChoosed) ? .appTextWhite : .appSecondary300
    }

    var countChoosedFilterCategories: Int {
        filterCategories.filter { $0.isChoosed }.count
    }

    // API
    var isLoading: Bool {
        isLoadingMovies || isLoadingActors
    }

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

    var haveMoreMovies: Bool {
        return self.paginator.getNextPage(forKey: .movieList) != nil
    }

    var showMoviesSection: Bool {
        return movies.count > 0 || isLoadingMovies
    }

    var showLoadingIndicator: Bool {
        return (movies.count > 0 || movies.count == 0 && query.count >= minLengthOfQueryToSearch) && haveMoreMovies
    }

    var showNoResultPicture: Bool {
        if movies.count > 0 { return false }
        return !isLoadingMovies && query.count >= minLengthOfQueryToSearch
    }

    var showSearchPicture: Bool {
        if movies.count > 0 { return false }
        return !isLoadingMovies && query.count < minLengthOfQueryToSearch
    }
}
