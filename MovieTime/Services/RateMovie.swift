//
//  RateMovie.swift
//  MovieTime
//
//  Created by Артём Грищенко on 20.05.2023.
//

import Foundation
import RealmSwift

struct RateMovie {
    private let realm = try? Realm()

    func getRating(forId id: Int) -> Int {
        guard let realm else { return 0 }
        print("Objects: ", realm.objects(UserRatingDBModel.self))
        return getUserRatingById(id: id)?.rating ?? 0
    }

    private func getUserRatingById(id: Int) -> UserRatingDBModel? {
        guard let realm else { return nil }
        return realm.objects(UserRatingDBModel.self).filter("kpMovieId == \(id)").first
    }

    func setRating(forId id: Int, value: Int) {
        guard let realm else { return }
        try? realm.write {
            if let userRating = getUserRatingById(id: id) {
                userRating.rating = value
            } else {
                let userRating = UserRatingDBModel()
                userRating.kpMovieId = id
                userRating.rating = value
                realm.add(userRating)
            }
        }
    }
}
