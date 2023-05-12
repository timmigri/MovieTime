//
//  FilterCategory.swift
//  MovieTime
//
//  Created by Артём Грищенко on 12.05.2023.
//

import Foundation

extension FilterCategory {
    static func getCategories() -> [FilterCategory] {
        var categories = [FilterCategory]()
        categories.append(FilterCategory(pictureName: "ActionBackground", name: "Action", searchKey: "боевик"))
        categories.append(FilterCategory(pictureName: "WarBackground", name: "War", searchKey: "военный"))
        categories.append(FilterCategory(pictureName: "HorrorBackground", name: "Horror", searchKey: "ужасы"))
        categories.append(FilterCategory(pictureName: "ThrillerBackground", name: "Thriller", searchKey: "триллер"))
        categories.append(FilterCategory(pictureName: "RomanceBackground", name: "Romance", searchKey: "мелодрама"))
        categories.append(FilterCategory(pictureName: "WesternsBackground", name: "Western", searchKey: "вестерн"))
        categories.append(FilterCategory(
            pictureName: "AnimationBackground", name: "Animation", searchKey: "мультфильм"))
        return categories
    }
}
