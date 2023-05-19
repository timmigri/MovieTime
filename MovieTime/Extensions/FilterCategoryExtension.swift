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
        categories.append(FilterCategoryModel(pictureName: "Action", name: "Action", searchKey: "боевик"))
        categories.append(FilterCategoryModel(pictureName: "War", name: "War", searchKey: "военный"))
        categories.append(FilterCategoryModel(pictureName: "Horror", name: "Horror", searchKey: "ужасы"))
        categories.append(FilterCategoryModel(pictureName: "Thriller", name: "Thriller", searchKey: "триллер"))
        categories.append(FilterCategoryModel(pictureName: "Romance", name: "Romance", searchKey: "мелодрама"))
        categories.append(FilterCategoryModel(pictureName: "Westerns", name: "Western", searchKey: "вестерн"))
        categories.append(FilterCategoryModel(pictureName: "Comedy", name: "Comedy", searchKey: "комедия"))
        categories.append(FilterCategoryModel(pictureName: "Animation", name: "Animation", searchKey: "мультфильм"))
        categories.append(FilterCategoryModel(pictureName: "Mystery", name: "Mystery", searchKey: "фантастика"))
        categories.append(FilterCategoryModel(pictureName: "Fantasy", name: "Fantasy", searchKey: "фэнетзи"))
        categories.append(FilterCategoryModel(pictureName: "Music", name: "Concerts", searchKey: "концерт"))
        categories.append(FilterCategoryModel(pictureName: "Family", name: "Family", searchKey: "семейный"))
        return categories
    }
}
