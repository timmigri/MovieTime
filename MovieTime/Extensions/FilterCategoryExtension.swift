//
//  FilterCategory.swift
//  MovieTime
//
//  Created by Артём Грищенко on 12.05.2023.
//

import Foundation

extension FilterCategoryModel {
    static func generateCategories() -> [FilterCategoryModel] {
        var categories = [FilterCategoryModel]()
        categories.append(FilterCategoryModel(
            pictureName: R.image.filterBackgrounds.action.name,
            name: R.string.filter.categoryAction(),
            searchKey: FilterSearchKeys.action.rawValue
        ))
        categories.append(FilterCategoryModel(
            pictureName: R.image.filterBackgrounds.war.name,
            name: R.string.filter.categoryWar(),
            searchKey: FilterSearchKeys.war.rawValue
        ))
        categories.append(FilterCategoryModel(
            pictureName: R.image.filterBackgrounds.horror.name,
            name: R.string.filter.categoryHorror(),
            searchKey: FilterSearchKeys.horror.rawValue
        ))
        categories.append(FilterCategoryModel(
            pictureName: R.image.filterBackgrounds.thriller.name,
            name: R.string.filter.categoryThriler(),
            searchKey: FilterSearchKeys.thriller.rawValue
        ))
        categories.append(FilterCategoryModel(
            pictureName: R.image.filterBackgrounds.romance.name,
            name: R.string.filter.categoryRomance(),
            searchKey: FilterSearchKeys.romance.rawValue
        ))
        categories.append(FilterCategoryModel(
            pictureName: R.image.filterBackgrounds.westerns.name,
            name: R.string.filter.categoryWesterns(),
            searchKey: FilterSearchKeys.westerns.rawValue
        ))
        categories.append(FilterCategoryModel(
            pictureName: R.image.filterBackgrounds.comedy.name,
            name: R.string.filter.categoryComedy(),
            searchKey: FilterSearchKeys.comedy.rawValue
        ))
        categories.append(FilterCategoryModel(
            pictureName: R.image.filterBackgrounds.animation.name,
            name: R.string.filter.categoryAnimation(),
            searchKey: FilterSearchKeys.animation.rawValue
        ))
        categories.append(FilterCategoryModel(
            pictureName: R.image.filterBackgrounds.mystery.name,
            name: R.string.filter.categoryMystery(),
            searchKey: FilterSearchKeys.mystery.rawValue
        ))
        categories.append(FilterCategoryModel(
            pictureName: R.image.filterBackgrounds.fantasy.name,
            name: R.string.filter.categoryFantasy(),
            searchKey: FilterSearchKeys.fantasy.rawValue
        ))
        categories.append(FilterCategoryModel(
            pictureName: R.image.filterBackgrounds.music.name,
            name: R.string.filter.categoryMusic(),
            searchKey: FilterSearchKeys.music.rawValue
        ))
        categories.append(FilterCategoryModel(
            pictureName: R.image.filterBackgrounds.family.name,
            name: R.string.filter.categoryFamily(),
            searchKey: FilterSearchKeys.family.rawValue
        ))
        return categories
    }
}

extension FilterCategoryModel {
    enum FilterSearchKeys: String {
        case action = "боевик"
        case war = "военный"
        case horror = "ужасы"
        case thriller = "триллер"
        case romance = "мелодрама"
        case westerns = "вестерн"
        case comedy = "комедия"
        case animation = "мультфильм"
        case mystery = "фантастика"
        case fantasy = "фэнтези"
        case music = "концерт"
        case family = "семейный"
    }
}
