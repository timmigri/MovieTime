//
//  MovieDetailViewModel.swift
//  MovieTime
//
//  Created by Артём Грищенко on 15.05.2023.
//

import Foundation
import SwiftUI

class MovieDetailViewModel: ObservableObject {
    let id: Int
    @Published var isLoadingMovie: Bool
    @Published var movie: MovieDetailModel?
    @Published var scrollViewOffset: CGFloat = 0.0
    @Published var userRating: Int?
    @Injected var networkManager: NetworkManager
    let defaults = UserDefaults.standard

    init(id: Int) {
        self.id = id
        self.isLoadingMovie = false
    }

    // UI Conditions
    func showAdvancedTopBar(_ screenHeight: CGFloat) -> Bool {
        movie != nil && scrollViewOffset < screenHeight * 0.6
    }

    var showMovieContent: Bool {
        !isLoadingMovie && movie != nil
    }

    var showNoResultPicture: Bool {
        !isLoadingMovie && movie == nil
    }

    func loadMovie() {
        print("Load movie: \(id)")
        isLoadingMovie = true
        networkManager.loadMovie(id: id) { res in
            DispatchQueue.main.async {
                self.movie = res
                self.isLoadingMovie = false
                if let key = self.getKeyForUserDefaults() {
                    self.userRating = self.defaults.integer(forKey: key)
                }
            }
        }
    }

    func onUpdateScrollPosition(_ value: CGFloat) {
        scrollViewOffset = value
    }

    func getKeyForUserDefaults() -> String? {
        if movie == nil { return nil }
        return "movie_rating_" + String(movie!.id)
    }

    func onChangeRating(value: Int?) {
        userRating = value
        if let key = getKeyForUserDefaults() {
            defaults.set(value, forKey: key)
        }
    }
}
