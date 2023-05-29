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
    private let maxFilterCategories = 3
    private let minLengthOfQueryToSearch = 3
    @Injected private var networkManager: NetworkManager
    @Injected private var paginator: Paginator
    @Injected private var rateMovie: RateMovie

    @Published private(set) var personState: PersonState = .blank
    @Published private(set) var filterCategories = FilterCategoryModel.generateCategories()
    @Published private(set) var isLoadingMovies = false
    @Published private(set) var movies = [MovieModel]()
    @Published var sortOptions = [
        CustomSelect.SelectOption(title: "Названию", key: "name"),
        CustomSelect.SelectOption(title: "Году", key: "year"),
        CustomSelect.SelectOption(title: "Рейтингу", key: "rating.kp")
    ]
    @Published var query = ""
    @Published var isUserTyping = false
    private var oldQuery = ""
    private var subscriptions = Set<AnyCancellable>()

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

    // Animation
    @Published private(set) var filterCategoriesVisibility: [Bool] = Array(
        repeating: false,
        count: FilterCategoryModel.generateCategories().count
    )

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

    // Sort option
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

    // Filter categories
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
        return category.isSelected || countSelectedFilterCategories < maxFilterCategories
    }

    var countSelectedFilterCategories: Int {
        filterCategories.filter { $0.isSelected }.count
    }

    var showMoviesSection: Bool {
        return movies.count > 0 || isLoadingMovies
    }

//    var showNoResultPicture: Bool {
//        if showMoviesSection || showActorsSection || isUserTyping { return false }
//        return query.count >= minLengthOfQueryToSearch
//    }
//
//    var showSearchPicture: Bool {
//        if showMoviesSection || showActorsSection { return false }
//        return !showNoResultPicture
//    }

    // API
    func onChangeSearchOptions() {
        movies = []
        personState = .blank
        paginator.reset(forKey: .movieList)
        paginator.reset(forKey: .actorList)
        loadMovies()
        loadActors()
    }

    func loadMovies() {
        if isLoadingMovies || query.count < minLengthOfQueryToSearch { return }
        isLoadingMovies = true
        let sortField = currentSortOptionIndex != nil ? sortOptions[currentSortOptionIndex!].key : nil
        let genres = filterCategories.filter { $0.isSelected }.map { $0.searchKey }
        // TODO: error handling
        networkManager.loadMovies(query: query.lowercased(), sortField: sortField, genres: genres) { (res) in
            DispatchQueue.main.async {
                self.movies += res
                self.isLoadingMovies = false
            }
        }
    }

    func loadActors() {
        if personState.isLoading || query.count < minLengthOfQueryToSearch { return }
        var persons = personState.persons
        personState = .success(persons: persons, isLoadingNext: true)
        networkManager.fetchPersons(query) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let personsResponse):
                persons += DTOConverter.convert(personsResponse)
                self.personState = .success(persons: persons, isLoadingNext: false)
            case .failure(let error):
                print(error.localizedDescription)
                self.personState = .error(error: "Произошла ошибка при загрузке актеров.")
            }
        }
    }
}

extension SearchViewModel {
    enum PersonState {
        static let blank = PersonState.success(persons: [], isLoadingNext: false)

        case success(persons: [PersonModel], isLoadingNext: Bool)
        case error(error: String)

        var persons: [PersonModel] {
            switch self {
            case .success(let persons, _):
                return persons
            case .error:
                return []
            }
        }

        var isLoading: Bool {
            switch self {
            case .success(_, let isLoadingNext):
                return isLoadingNext
            case .error:
                return false
            }
        }
    }
}
