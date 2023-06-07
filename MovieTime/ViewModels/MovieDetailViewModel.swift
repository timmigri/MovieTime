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
        case database(kpId: Int?, uuid: UUID?)
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
    @Published private(set) var screenState: ScreenState = .loading
    @Published private(set) var scrollViewOffset: CGFloat = 0.0
    @Published private(set) var userRating: Int = 0
    @AuthInjected private var movieRatingRepository: MovieRatingRepository
    @AuthInjected private var movieRepository: MovieRepository
    @AuthInjected private var networkManager: NetworkManager
    @Published var isBookmarked: Bool = false
    let isCustomMovie: Bool

    // Animation
    @Published var bookmarkButtonScale: CGFloat = 1

    init(source: Source) {
        self.source = source
        if case .database(let kpId, _) = source {
            isCustomMovie = kpId == nil
        } else {
            isCustomMovie = false
        }
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

    func onTapBookmarkButton() {
        guard let movie = screenState.movie else { return }
        guard let res = movieRepository.toggleMovie(movie: movie) else { return }

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
        case .success(let movie):
            movie.posterImage = image.pngData()
            screenState = .success(movie: movie)
        default:
            break
        }
    }

    private func onSuccessLoadingMovie(_ movie: MovieDetailModel) {
        if let kpId = movie.kpId {
            self.userRating = movieRatingRepository.getRating(forId: kpId)
        }
        self.isBookmarked = movieRepository.containsMovie(kpId: movie.kpId, uuid: movie.uuid)
        self.screenState = .success(movie: movie)
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
        case .database(let kpId, let uuid):
            screenState = .loading
            if let movieEntity = movieRepository.getMovie(kpId: kpId, uuid: uuid) {
                let movie = EntityConverter.convertFrom(movieEntity)
                self.onSuccessLoadingMovie(movie)
            } else {
                screenState = .error
            }
        }
    }

    func onUpdateScrollPosition(_ value: CGFloat) {
        scrollViewOffset = value
    }

    func onChangeRating(value: Int) {
        if let movie = screenState.movie {
            userRating = value
            if let kpId = movie.kpId {
                movieRatingRepository.setRating(forId: kpId, value: value)
            }
        }
    }

    func shareMovie() {
        guard let movie = screenState.movie else { return }
        guard let source = UIApplication.shared.getCurrentViewController() else { return }
        ShareService.shareMovie(movie as MovieModel, source: source)
    }
}
