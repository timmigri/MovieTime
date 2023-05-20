//
//  RateMovie.swift
//  MovieTime
//
//  Created by Артём Грищенко on 20.05.2023.
//

import Foundation

struct RateMovie {
    private func getKey(forId id: Int) -> String {
        return "movie_rating_" + String(id)
    }

    func getRating(forId id: Int) -> Int {
        let key = getKey(forId: id)
        return UserDefaults.standard.integer(forKey: key)
    }

    func setRating(forId id: Int, value: Int) {
        let key = getKey(forId: id)
        UserDefaults.standard.set(value, forKey: key)
    }
}
