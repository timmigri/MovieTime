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

    enum ScreenState {
        case loading
        case success(movie: MovieDetailModel)
        case error
        
        var movie: MovieDetailModel? {
            switch self {
            case .success(let movie):
                return movie
            default:
                return nil
            }
        }
    }
    
    let source: Source
//    @Published private(set) var isLoadingMovie: Bool = false
//    @Published private(set) var movie: MovieDetailModel?
    @Published private(set) var screenState: ScreenState = .loading
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
        switch screenState {
        case .success:
            return scrollViewOffset < screenHeight * 0.6
        default:
            return false
        }
    }

//    var showActorsCondition: (Bool, [PersonModel]) {
//        guard let movie else { return (false, []) }
//        guard let actors = movie.actors else { return (false, []) }
//        return (actors.count > 0, actors)
//    }

//    var showDescriptionCondition: (Bool, String) {
//        guard let movie else { return (false, "") }
//        guard let description = movie.description else { return (false, "") }
//        return (description.count > 0, description)
//    }

    func onTapBookmarkButton() {
        guard let movie = screenState.movie else { return }
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
        guard let movie = screenState.movie else { return nil }
        guard let posterUrl = movie.posterUrl else { return nil }
        return URL(string: posterUrl)
    }

    var showBookmarkButton: Bool {
        if posterUrl == nil { return true }
        return screenState.movie?.posterImage != nil
    }

    func onFinishLoadingPoster(image: UIImage?) {
        guard let image else { return }
        switch screenState {
        case .success(var movie):
            movie.posterImage = image.pngData()
            screenState = .success(movie: movie)
        default:
            break
        }
    }
    
    private func onSuccessLoadingMovie(_ movie: MovieDetailModel) {
        self.screenState = .success(movie: movie)
        self.userRating = self.rateMovie.getRating(forId: movie.id)
        self.isBookmarked = self.bookmarkMovieService.isMovieBookmarked(id: movie.id)
    }

    func loadMovie() {
        switch source {
        case .network(let kpId):
            screenState = .loading
            networkManager.fetchMovie(id: kpId) { [weak self] result in
                guard let self else { return }

                switch result {
                case .success(let movieResponse):
                    let movie = DTOConverter.convert(movieResponse)
                    guard let movie else { fallthrough }
                    self.onSuccessLoadingMovie(movie)
                case .failure:
                    self.screenState = .error
                }
            }
        case .database(let movie):
            self.onSuccessLoadingMovie(movie)
        }
    }

    func onUpdateScrollPosition(_ value: CGFloat) {
        scrollViewOffset = value
    }

    func onChangeRating(value: Int) {
        if let movie = screenState.movie {
            userRating = value
            rateMovie.setRating(forId: movie.id, value: value)
        }
    }

    func shareMovie(source: UIViewController) {
        guard let movie = screenState.movie else { return }
        var items = [Any]()
        items.append(URL(string: "https://www.google.com")!)
        items.append("Рекомендую: \(movie.name) (\(movie.year))")
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        vc.popoverPresentationController?.sourceView = source.view
        source.present(vc, animated: true)
    }
}
