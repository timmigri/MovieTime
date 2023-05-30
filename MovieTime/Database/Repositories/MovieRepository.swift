//
//  MovieRepository.swift
//  MovieTime
//
//  Created by Артём Грищенко on 31.05.2023.
//

import Foundation
import RealmSwift

class MovieRepository: MovieRepositoryProtocol {    
    private let realm = try? Realm()

    func getMovieById(id: Int) -> MovieEntity? {
        guard let realm else { return nil }
        return realm.objects(MovieEntity.self).filter("kpId == \(id)").first
    }

    func containsMovie(id: Int) -> Bool {
        return getMovieById(id: id) != nil
    }

    func toggleMovie(forMovieId id: Int, movie: MovieDetailModel) -> Bool? {
        guard let realm else { return nil }
        var res: Bool?
        try? realm.write {
            if let movie = getMovieById(id: id) {
                realm.delete(movie)
                res = false
            } else {
                let movieEntity = EntityConverter.convertTo(movie)
                realm.add(movieEntity)
                res = true
            }
        }
        return res
    }
    
    func getAllMovies() -> Results<MovieEntity>? {
        return realm?.objects(MovieEntity.self)
    }
    
    func applyFilters(_ results: Results<MovieEntity>, query: String, sortKey: String?, ascending: Bool) -> Results<MovieEntity> {
        var dbResult = results
        if query.count > 0 {
            dbResult = dbResult.filter("name contains[cd] %@", query.lowercased())
        }
        if let sortKey {
            dbResult = dbResult.sorted(byKeyPath: sortKey, ascending: ascending)
        }
        return dbResult
    }
}
