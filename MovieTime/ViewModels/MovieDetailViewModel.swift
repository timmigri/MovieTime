//
//  MovieDetailViewModel.swift
//  MovieTime
//
//  Created by Артём Грищенко on 15.05.2023.
//

import Foundation
import SwiftUI

class MovieDetailViewModel: ObservableObject {
    enum Source {
        case network(kpId: Int?)
        case database(movie: MovieDetailModel)
    }
    
    let source: Source
    @Published private(set) var isLoadingMovie: Bool = false
    @Published private(set) var movie: MovieDetailModel?
    @Published private(set) var scrollViewOffset: CGFloat = 0.0
    @Published private(set) var userRating: Int = 0
    @Injected private var rateMovie: RateMovie
    @Injected private var bookmarkMovieService: BookmarkMovieService
    @Injected private var networkManager: NetworkManager
    @Published var isBookmarked: Bool = false

    // Animation
    @Published var bookmarkButtonScale: CGFloat = 1

    init(source: Source) {
        self.source = source
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

    var showActorsCondition: (Bool, [PersonModel]) {
        guard let movie else { return (false, []) }
        guard let actors = movie.actors else { return (false, []) }
        return (actors.count > 0, actors)
    }

    var showDescriptionCondition: (Bool, String) {
        guard let movie else { return (false, "") }
        guard let description = movie.description else { return (false, "") }
        return (description.count > 0, description)
    }

    func onTapBookmarkButton() {
        guard let movie = self.movie else { return }
        let res = bookmarkMovieService.toggleBookmark(forMovieId: movie.id, movie: movie)
        guard let res else { return }

        isBookmarked = res
        if res {
            let duration = 0.3
            withAnimation(.easeInOut(duration: duration)) {
                bookmarkButtonScale = 1.2
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                withAnimation(.easeInOut(duration: duration)) {
                    self.bookmarkButtonScale = 1
                }
            }
        }
    }

    var posterUrl: URL? {
        guard let movie else { return nil }
        guard let posterUrl = movie.posterUrl else { return nil }
        return URL(string: posterUrl)
    }

    var showBookmarkButton: Bool {
        if posterUrl == nil { return true }
        return movie?.posterImage != nil
    }

    func onFinishLoadingPoster(image: UIImage?) {
        guard let image else { return }
        movie?.posterImage = image.pngData()
    }

    func loadMovie() {
        switch source {
        case .network(let kpId):
            isLoadingMovie = true
            networkManager.loadMovie(id: kpId) { res in
                DispatchQueue.main.async {
                    self.movie = res
                    self.isLoadingMovie = false
                    if let res {
                        self.userRating = self.rateMovie.getRating(forId: res.id)
                        self.isBookmarked = self.bookmarkMovieService.isMovieBookmarked(id: res.id)
                    }
                }
            }
        case .database(let movie):
            self.movie = movie
            self.userRating = self.rateMovie.getRating(forId: movie.id)
            self.isBookmarked = self.bookmarkMovieService.isMovieBookmarked(id: movie.id)
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

    func shareMovie(source: UIViewController) {
        guard let movie else {
            return
        }
        var items = [Any]()
        items.append(URL(string: "https://www.google.com")!)
        items.append("Рекомендую: \(movie.name) (\(movie.year))")
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        vc.popoverPresentationController?.sourceView = source.view
        source.present(vc, animated: true)
    }
}
