//
//  SearchViewModel.swift
//  MovieTime
//
//  Created by Артём Грищенко on 12.05.2023.
//

import Foundation
import SwiftUI
import Combine

class SearchViewModel: ObservableObject {
    @Injected private var networkManager: NetworkManager
    @Injected private var paginator: NetworkPaginator
    @Injected private var rateMovie: RateMovie

    init() {
        $query
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] text in
                if text != self?.oldQuery {
                    self?.onChangeSearchOptions()
                }
                self?.oldQuery = text
                self?.isUserTyping = false
            })
            .store(in: &subscriptions)
    }

    // MARK: Screen state
    enum ScreenState {
        case searchPicture
        case noResultPicture
        case results
    }

    var screenState: ScreenState {
        if showPersonsList || showMoviesList { return .results }
        if query.count < AppConstants.minLengthOfQueryToSearch || isUserTyping { return .searchPicture }
        return .noResultPicture
    }

    // MARK: Sort and filter
    private var oldQuery = ""
    private var subscriptions = Set<AnyCancellable>()
    @Published var query = ""
    @Published var isUserTyping = false
    @Published private(set) var filterCategoriesVisibility: [Bool] = Array(
        repeating: false,
        count: FilterCategoryModel.generateCategories().count
    )
    @Published var sortOptions = [
        CustomSelect.SelectOption(title: R.string.filter.sortOptionName(), key: "name"),
        CustomSelect.SelectOption(title: R.string.filter.sortOptionYear(), key: "year"),
        CustomSelect.SelectOption(title: R.string.filter.sortOptionRating(), key: "rating.kp")
    ]
    @Published private(set) var filterCategories = FilterCategoryModel.generateCategories()

    func onAppearFilterScreenView() {
        for index in filterCategoriesVisibility.indices { filterCategoriesVisibility[index] = false }
        let totalDuration: CGFloat = 0.5
        for index in filterCategoriesVisibility.indices {
            let after: CGFloat = totalDuration * CGFloat(index + 1) / CGFloat(filterCategoriesVisibility.count)
            DispatchQueue.main.asyncAfter(deadline: .now() + after) {
                withAnimation {
                    self.filterCategoriesVisibility[index] = true
                }
            }
        }
    }

    var currentSortOptionIndex: Int? {
        if let index = sortOptions.firstIndex(where: { $0.isSelected }) {
            return index
        }
        return nil
    }

    func onSelectSortOption(_ index: Int, _ key: String) {
        withAnimation(.easeInOut(duration: 0.2)) {
            if !sortOptions[index].isSelected {
                for ind in sortOptions.indices { sortOptions[ind].isSelected = false }
            }
            sortOptions[index].isSelected.toggle()
        }
    }

    var isSomeFilterActive: Bool {
        currentSortOptionIndex != nil || countSelectedFilterCategories > 0
    }

    func onChooseFilterCategory(_ id: String) {
        if let index = filterCategories.firstIndex(where: { $0.id == id }),
           canSelectFilterCategory(filterCategories[index]) {
            withAnimation(.easeInOut(duration: 0.2)) {
                filterCategories[index].isSelected.toggle()
            }
        }
    }

    func resetFilterCategories() {
        withAnimation(.easeInOut(duration: 0.2)) {
            for index in filterCategories.indices {
                filterCategories[index].isSelected = false
            }
        }
    }

    func canSelectFilterCategory(_ category: FilterCategoryModel) -> Bool {
        return category.isSelected || countSelectedFilterCategories < AppConstants.maxFilterCategories
    }

    var countSelectedFilterCategories: Int {
        filterCategories.filter { $0.isSelected }.count
    }

    func onChangeSearchOptions() {
        clearMovieState()
        clearPersonState()
        loadMovies()
        loadPersons()
    }

    // MARK: Person state
    @Published private(set) var persons = [PersonModel]()
    @Published private(set) var isLoadingPersons = false
    @Published private(set) var personsLoadingError: String?

    var showPersonsList: Bool {
        return persons.count > 0 || isLoadingPersons
    }

    private func onSuccessLoadingPersons(_ newPersons: [PersonModel]) {
        persons += newPersons
        isLoadingPersons = false
        personsLoadingError = nil
    }

    private func onErrorLoadingPersons() {
        persons = []
        isLoadingPersons = false
        personsLoadingError = R.string.search.errorLoadingPersons()
    }

    private func onStartLoadingPersons() {
        isLoadingPersons = true
        personsLoadingError = nil
    }

    private func clearPersonState() {
        persons = []
        personsLoadingError = nil
        paginator.reset(forKey: .personList)
    }

    func loadPersons() {
        if isLoadingPersons || query.count < AppConstants.minLengthOfQueryToSearch { return }
        onStartLoadingPersons()
        networkManager.fetchPersons(query) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let personsResponse):
                self.onSuccessLoadingPersons(DTOConverter.convert(personsResponse))
            case .failure:
                self.onErrorLoadingPersons()
            }
        }
    }

    // MARK: Movie state
    @Published private(set) var isLoadingMovies = false
    @Published private(set) var movies = [MovieModel]()
    @Published private(set) var moviesLoadingError: String?

    private func onSuccessLoadingMovies(_ newMovies: [MovieModel]) {
        movies += newMovies
        isLoadingMovies = false
        moviesLoadingError = nil
    }

    private func onErrorLoadingMovies() {
        movies = []
        isLoadingMovies = false
        moviesLoadingError = R.string.search.errorLoadingMovies()
    }

    private func onStartLoadingMovies() {
        isLoadingMovies = true
        moviesLoadingError = nil
    }

    private func clearMovieState() {
        movies = []
        moviesLoadingError = nil
        paginator.reset(forKey: .movieList)
    }

    var showMoviesList: Bool {
        return movies.count > 0 || isLoadingMovies
    }

    func loadMovies() {
        if isLoadingMovies || query.count < AppConstants.minLengthOfQueryToSearch { return }
        onStartLoadingMovies()
        let sortField = currentSortOptionIndex != nil ? sortOptions[currentSortOptionIndex!].key : nil
        let genres = filterCategories.filter { $0.isSelected }.map { $0.searchKey }
        networkManager.fetchMovies(query: query.lowercased(), sortField: sortField, genres: genres) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let moviesResponse):
                self.onSuccessLoadingMovies(DTOConverter.convert(moviesResponse))
            case .failure:
                self.onErrorLoadingMovies()
            }
        }
    }
}
