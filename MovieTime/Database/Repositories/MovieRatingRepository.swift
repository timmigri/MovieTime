//
//  MovieRatingRepository.swift
//  MovieTime
//
//  Created by Артём Грищенко on 31.05.2023.
//

import Foundation
import RealmSwift

class MovieRatingRepository: MovieRatingRepositoryProtocol {
    private let realm = try? Realm()

    private func getMovieRatingEntityById(id: Int) -> MovieRatingEntity? {
        guard let realm else { return nil }
        return realm.objects(MovieRatingEntity.self).filter("kpMovieId == \(id)").first
    }

    func getRating(forId id: Int) -> Int {
        return getMovieRatingEntityById(id: id)?.rating ?? 0
    }

    func setRating(forId id: Int, value: Int) {
        guard let realm else { return }
        try? realm.write {
            if let userRating = getMovieRatingEntityById(id: id) {
                userRating.rating = value
            } else {
                let userRating = MovieRatingEntity()
                userRating.kpMovieId = id
                userRating.rating = value
                realm.add(userRating)
            }
        }
    }
}
