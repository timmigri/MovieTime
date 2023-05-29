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
        guard let realm else { return nil }
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
                movieDb.image = movie.posterImage
                realm.add(movieDb)
                res = true
            }
        }
        return res
    }

    func getMoviesList(query: String, sortKey: String?, ascending: Bool = false) -> ([MovieDetailModel], Int) {
        guard let realm = self.realm else { return ([], 0) }
        var dbResult = realm.objects(MovieDBModel.self)
        let totalCount = dbResult.count
        if query.count > 0 {
            dbResult = dbResult.filter("name contains[cd] %@", query.lowercased())
        }
        if let sortKey {
            dbResult = dbResult.sorted(byKeyPath: sortKey, ascending: ascending)
        }
        print(dbResult)
        return (Array(dbResult).map { MovieDetailModel.processDbData($0) }, totalCount)
    }
}
