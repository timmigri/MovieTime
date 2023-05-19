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
        categories.append(FilterCategoryModel(pictureName: "Action", name: "Боевик", searchKey: "боевик"))
        categories.append(FilterCategoryModel(pictureName: "War", name: "Военный", searchKey: "военный"))
        categories.append(FilterCategoryModel(pictureName: "Horror", name: "Ужасы", searchKey: "ужасы"))
        categories.append(FilterCategoryModel(pictureName: "Thriller", name: "Триллер", searchKey: "триллер"))
        categories.append(FilterCategoryModel(pictureName: "Romance", name: "Мелодрама", searchKey: "мелодрама"))
        categories.append(FilterCategoryModel(pictureName: "Westerns", name: "Вестерн", searchKey: "вестерн"))
        categories.append(FilterCategoryModel(pictureName: "Comedy", name: "Комедия", searchKey: "комедия"))
        categories.append(FilterCategoryModel(pictureName: "Animation", name: "Мультфильм", searchKey: "мультфильм"))
        categories.append(FilterCategoryModel(pictureName: "Mystery", name: "Фантастика", searchKey: "фантастика"))
        categories.append(FilterCategoryModel(pictureName: "Fantasy", name: "Фэнтези", searchKey: "фэнтези"))
        categories.append(FilterCategoryModel(pictureName: "Music", name: "Концерт", searchKey: "концерт"))
        categories.append(FilterCategoryModel(pictureName: "Family", name: "Семейный", searchKey: "семейный"))
        return categories
    }
}
