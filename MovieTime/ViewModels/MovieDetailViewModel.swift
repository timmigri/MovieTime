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
    @Published var userRating: Int = 0
    @Injected private var rateMovie: RateMovie
    @Injected private var networkManager: NetworkManager
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
        isLoadingMovie = true
        networkManager.loadMovie(id: id) { res in
            DispatchQueue.main.async {
                self.movie = res
                self.isLoadingMovie = false
                if let res {
                    self.userRating = self.rateMovie.getRating(forId: res.id)
                }
            }
        }
    }

    func onUpdateScrollPosition(_ value: CGFloat) {
        scrollViewOffset = value
    }

    func onChangeRating(value: Int) {
        if let movie {
            userRating = value
            rateMovie.setRating(forId: movie.id, value: value)
        }
    }
}
