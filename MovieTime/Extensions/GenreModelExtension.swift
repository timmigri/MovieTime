//
//  GenreModelExtension.swift
//  MovieTime
//
//  Created by Артём Грищенко on 12.05.2023.
//

import Foundation

extension GenreModel {
    static func generateBasicGenres() -> [GenreModel] {
        var genres = [GenreModel]()
        genres.append(GenreModel(
            name: R.string.filter.categoryAction().lowercased(),
            pictureName: R.image.filterBackgrounds.action.name,
            searchKey: GenreSearchKeys.action.rawValue
        ))
        genres.append(GenreModel(
            name: R.string.filter.categoryWar().lowercased(),
            pictureName: R.image.filterBackgrounds.war.name,
            searchKey: GenreSearchKeys.war.rawValue
        ))
        genres.append(GenreModel(
            name: R.string.filter.categoryHorror().lowercased(),
            pictureName: R.image.filterBackgrounds.horror.name,
            searchKey: GenreSearchKeys.horror.rawValue
        ))
        genres.append(GenreModel(
            name: R.string.filter.categoryThriler().lowercased(),
            pictureName: R.image.filterBackgrounds.thriller.name,
            searchKey: GenreSearchKeys.thriller.rawValue
        ))
        genres.append(GenreModel(
            name: R.string.filter.categoryRomance().lowercased(),
            pictureName: R.image.filterBackgrounds.romance.name,
            searchKey: GenreSearchKeys.romance.rawValue
        ))
        genres.append(GenreModel(
            name: R.string.filter.categoryWesterns().lowercased(),
            pictureName: R.image.filterBackgrounds.westerns.name,
            searchKey: GenreSearchKeys.westerns.rawValue
        ))
        genres.append(GenreModel(
            name: R.string.filter.categoryComedy().lowercased(),
            pictureName: R.image.filterBackgrounds.comedy.name,
            searchKey: GenreSearchKeys.comedy.rawValue
        ))
        genres.append(GenreModel(
            name: R.string.filter.categoryAnimation().lowercased(),
            pictureName: R.image.filterBackgrounds.animation.name,
            searchKey: GenreSearchKeys.animation.rawValue
        ))
        genres.append(GenreModel(
            name: R.string.filter.categoryMystery().lowercased(),
            pictureName: R.image.filterBackgrounds.mystery.name,
            searchKey: GenreSearchKeys.mystery.rawValue
        ))
        genres.append(GenreModel(
            name: R.string.filter.categoryFantasy().lowercased(),
            pictureName: R.image.filterBackgrounds.fantasy.name,
            searchKey: GenreSearchKeys.fantasy.rawValue
        ))
        genres.append(GenreModel(
            name: R.string.filter.categoryMusic().lowercased(),
            pictureName: R.image.filterBackgrounds.music.name,
            searchKey: GenreSearchKeys.music.rawValue
        ))
        genres.append(GenreModel(
            name: R.string.filter.categoryFamily().lowercased(),
            pictureName: R.image.filterBackgrounds.family.name,
            searchKey: GenreSearchKeys.family.rawValue
        ))
        return genres
    }
}

extension GenreModel {
    enum GenreSearchKeys: String {
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
