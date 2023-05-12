//
//  SearchViewModel.swift
//  MovieTime
//
//  Created by Артём Грищенко on 12.05.2023.
//

import Foundation
import SwiftUI

class SearchViewModel: ObservableObject {
    let sortOptions = [("Title", "title"), ("Date", "date"), ("Rating", "rating")]
    let maxFilterCategories = 3
    @Published var currentSortOptionIndex: Int?
    @Published var filterCategories = FilterCategory.generateCategories()

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
}
