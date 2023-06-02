//
//  MovieRepository.swift
//  MovieTime
//
//  Created by Артём Грищенко on 31.05.2023.
//

import Foundation
import RealmSwift

class MovieRepository: MovieRepositoryProtocol {
    private let realm: Realm?

    init() {
        self.realm = try? Realm()
        createBasicGenres()
    }

    private func getGenreByName(name: String) -> GenreEntity? {
        guard let realm else { return nil }
        return realm.objects(GenreEntity.self).filter("name == \"\(name)\"").first
    }

    private func getPersonByKpId(kpId: Int) -> PersonEntity? {
        guard let realm else { return nil }
        return realm.objects(PersonEntity.self).filter("kpId == \(kpId)").first
    }

    func getMovie(kpId: Int?, uuid: UUID?) -> MovieEntity? {
        guard let realm else { return nil }
        if let kpId {
            return realm.objects(MovieEntity.self).filter("kpId == \(kpId)").first
        }
        if let uuid {
            return realm.objects(MovieEntity.self).filter("uuid == \"\(uuid)\"").first
        }
        return nil
    }

    func containsMovie(kpId: Int?, uuid: UUID?) -> Bool {
        return getMovie(kpId: kpId, uuid: uuid) != nil
    }

    func toggleMovie(movie: MovieDetailModel) -> Bool? {
        guard let realm else { return nil }
        var res: Bool?
        try? realm.write {
            if let movie = getMovie(kpId: movie.kpId, uuid: movie.uuid) {
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
                    var imageUrl: URL?
                    if let kpId = movie.kpId {
                        imageUrl = DeviceImage.getImagePathOnDevice(
                            .moviePoster(movieId: kpId))
                    }
                    if let uuid = movie.uuid {
                        imageUrl = DeviceImage.getImagePathOnDevice(
                            .customMoviePoster(movieUUID: uuid))
                    }
                    guard let imageUrl else { return }
                    guard let imageData = movie.posterImage else { return }
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

    func createBasicGenres() {
        guard let realm else { return }
        if realm.objects(GenreEntity.self).count > 0 { return }
        try? realm.write {
            for genre in GenreModel.generateBasicGenres() {
                realm.add(EntityConverter.convertTo(genre))
            }
        }
    }
}
