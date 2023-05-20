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
        container.register(NetworkManager.self) { _ in
            return NetworkManager()
        }
        container.register(RateMovie.self) { _ in
            return RateMovie()
        }.inObjectScope(.container)
        container.register(Paginator.self) { _ in
            return Paginator()
        }.inObjectScope(.container)
        container.register(SearchViewModel.self) { _ in
            return SearchViewModel()
        }.inObjectScope(.container)
        container.register(MovieDetailViewModel.self) { _, id in
            return MovieDetailViewModel(id: id)
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
