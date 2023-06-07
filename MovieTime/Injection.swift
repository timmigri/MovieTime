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

        // MARK: View models
        container.register(AuthViewModel.self) { _ in
            return AuthViewModel()
        }.inObjectScope(.container)
        return container
    }
}

final class AuthInjection {
    static let shared = AuthInjection()
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
    
    func clearContainer() {
        mContainer = nil
    }

    private func buildContainer() -> Container {
        let container = Container()

        // MARK: Network
        container.register(NetworkPaginator.self) { _ in
            return NetworkPaginator()
        }.inObjectScope(.container)
        container.register(NetworkManager.self) { _ in
            return NetworkManager()
        }

        // MARK: Database
        container.register(MovieRatingRepository.self) { _ in
            return MovieRatingRepository()
        }.inObjectScope(.container)
        container.register(MovieRepository.self) { _ in
            return MovieRepository()
        }.inObjectScope(.container)

        // MARK: View models
        container.register(BookmarkViewModel.self) { _ in
            return BookmarkViewModel()
        }.inObjectScope(.container)
        container.register(SearchViewModel.self) { _ in
            return SearchViewModel()
        }.inObjectScope(.container)
        container.register(MovieDetailViewModel.self) { _, source in
            return MovieDetailViewModel(source: source)
        }
        container.register(CustomMovieViewModel.self) { _, mode in
            return CustomMovieViewModel(mode: mode)
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

@propertyWrapper struct AuthInjected<Dependency> {
    let wrappedValue: Dependency

    init() {
        self.wrappedValue = AuthInjection.shared.container.resolve(Dependency.self)!
    }
}
