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
    private static let imagesFolder = "MovieTimePosters"

    private func getGenreByName(name: String) -> GenreEntity? {
        guard let realm else { return nil }
        return realm.objects(GenreEntity.self).filter("name == \"\(name)\"").first
    }

    private func getPersonByKpId(kpId: Int) -> PersonEntity? {
        guard let realm else { return nil }
        return realm.objects(PersonEntity.self).filter("kpId == \(kpId)").first
    }

    func getMovieById(id: Int) -> MovieEntity? {
        guard let realm else { return nil }
        return realm.objects(MovieEntity.self).filter("kpId == \(id)").first
    }

    func containsMovie(id: Int) -> Bool {
        return getMovieById(id: id) != nil
    }

    func toggleMovie(forMovieId id: Int, movie: MovieDetailModel) -> Bool? {
        guard let realm else { return nil }
        print(Realm.Configuration.defaultConfiguration.fileURL?.path)
        var res: Bool?
        try? realm.write {
            if let movie = getMovieById(id: id) {
                for person in movie.actors where person.movies.count == 1 {
                    realm.delete(person)
                }
                realm.delete(movie)
                res = false
            } else {
                let movieEntity = EntityConverter.convertTo(movie)
                for genre in movie.genres {
                    if let genreEntity = getGenreByName(name: genre.name) {
                        movieEntity.genres.append(genreEntity)
                        continue
                    }
                    let genreEntity = EntityConverter.convertTo(genre)
                    movieEntity.genres.append(genreEntity)
                }
                for actor in movie.actors {
                    if let personEntity = getPersonByKpId(kpId: actor.id) {
                        movieEntity.actors.append(personEntity)
                        continue
                    }
                    let personEntity = EntityConverter.convertTo(actor)
                    movieEntity.actors.append(personEntity)
                }
                realm.add(movieEntity)


                DispatchQueue.global(qos: .userInitiated).async {
                    guard let imageUrl = DeviceImage.getImagePathOnDevice(
                        .moviePoster(movieId: movie.id)) else { return }
                    guard let imageData = movie.posterImage else { return }
                    print(imageUrl)
                    do {
                        try imageData.write(to: imageUrl, options: .atomic)
                    } catch {
                        print(error)
                    }
                }
                res = true
            }
        }
        return res
    }

    func getAllMovies() -> Results<MovieEntity>? {
        return realm?.objects(MovieEntity.self)
    }

    func applyFilters(
        _ results: Results<MovieEntity>,
        query: String,
        sortKey: String?,
        ascending: Bool) -> Results<MovieEntity> {
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
