//
//  BookmarkMovieService.swift
//  MovieTime
//
//  Created by Артём Грищенко on 28.05.2023.
//

import Foundation
import RealmSwift

class BookmarkMovieService {
    private let realm = try? Realm()

    private func getMovieById(id: Int) -> MovieDBModel? {
        guard let realm else { return nil }
        return realm.objects(MovieDBModel.self).filter("kpId == \(id)").first
    }

    func isMovieBookmarked(id: Int) -> Bool {
        return getMovieById(id: id) != nil
    }

    // return true if now movie is bookmarked
    func toggleBookmark(forMovieId id: Int, movie: MovieDetailModel) -> Bool? {
        guard let realm else {
            print("amogues")
            return nil
        }
//        UIImagePNGRepresentation
        var res: Bool?
        try? realm.write {
            if let movie = getMovieById(id: id) {
                realm.delete(movie)
                res = false
            } else {
                let movieDb = MovieDBModel()
                movieDb.kpId = movie.id
                movieDb.name = movie.name
                movieDb.year = movie.year
                movieDb.movieLength = movie.movieLength
                movieDb.movieDescription = movie.description
                movieDb.rating = movie.rating
                realm.add(movieDb)
                res = true
            }
        }
        return res
    }
    
    func getMoviesList() -> [MovieDetailModel] {
        guard let realm = self.realm else { return [] }
        return Array(realm.objects(MovieDBModel.self)).map { MovieDetailModel.processDbData($0) }
    }
}
