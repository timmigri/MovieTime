//
//  FilterCategory.swift
//  MovieTime
//
//  Created by Артём Грищенко on 12.05.2023.
//

import Foundation

extension FilterCategory {
    static func generateCategories() -> [FilterCategory] {
        var categories = [FilterCategory]()
        categories.append(FilterCategory(pictureName: "ActionBackground", name: "Action", searchKey: "боевик"))
        categories.append(FilterCategory(pictureName: "WarBackground", name: "War", searchKey: "военный"))
        categories.append(FilterCategory(pictureName: "HorrorBackground", name: "Horror", searchKey: "ужасы"))
        categories.append(FilterCategory(pictureName: "ThrillerBackground", name: "Thriller", searchKey: "триллер"))
        categories.append(FilterCategory(pictureName: "RomanceBackground", name: "Romance", searchKey: "мелодрама"))
        categories.append(FilterCategory(pictureName: "WesternsBackground", name: "Western", searchKey: "вестерн"))
        categories.append(FilterCategory(pictureName: "ComedyBackground", name: "Comedy", searchKey: "комедия"))
        categories.append(FilterCategory(
            pictureName: "AnimationBackground", name: "Animation", searchKey: "мультфильм"))
        categories.append(FilterCategory(pictureName: "MysteryBackground", name: "Mystery", searchKey: "фантастика"))
        categories.append(FilterCategory(pictureName: "FantasyBackground", name: "Fantasy", searchKey: "фэнетзи"))
        categories.append(FilterCategory(pictureName: "MusicBackground", name: "Concerts", searchKey: "концерт"))
        categories.append(FilterCategory(pictureName: "FamilyBackground", name: "Family", searchKey: "семейный"))
        return categories
    }
}
