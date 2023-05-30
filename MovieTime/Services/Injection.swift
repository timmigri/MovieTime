//
//  Injection.swift
//  MovieTime
//
//  Created by Артём Грищенко on 13.05.2023.
//

import Foundation
import Swinject

final class Injection {
    static let shared = Injection()
    private var mContainer: Container?

    var container: Container {
        get {
            if mContainer == nil {
                mContainer = buildContainer()
            }
            return mContainer!
        }
        set {
            mContainer = newValue
        }
    }

    private func buildContainer() -> Container {
        let container = Container()
        
        // Network
        container.register(NetworkPaginator.self) { _ in
            return NetworkPaginator()
        }.inObjectScope(.container)

        // Services
        container.register(NetworkManager.self) { _ in
            return NetworkManager()
        }
        container.register(RateMovie.self) { _ in
            return RateMovie()
        }.inObjectScope(.container)
        container.register(BookmarkMovieService.self) { _ in
            return BookmarkMovieService()
        }.inObjectScope(.container)

        // View models
        container.register(AuthViewModel.self) { _ in
            return AuthViewModel()
        }.inObjectScope(.container)
        container.register(BookmarkViewModel.self) { _ in
            return BookmarkViewModel()
        }.inObjectScope(.container)
        container.register(SearchViewModel.self) { _ in
            return SearchViewModel()
        }.inObjectScope(.container)
        container.register(MovieDetailViewModel.self) { _, source in
            return MovieDetailViewModel(source: source)
        }
        return container
    }
}

@propertyWrapper struct Injected<Dependency> {
    let wrappedValue: Dependency

    init() {
        self.wrappedValue = Injection.shared.container.resolve(Dependency.self)!
    }
}
