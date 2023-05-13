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
        container.register(SearchViewModel.self) { _ in
            return SearchViewModel()
        }.inObjectScope(.container)
        return container
    }
}

@propertyWrapper struct Injected<Dependency> {
    let wrappedValue: Dependency

    init() {
        self.wrappedValue = Injection.shared.container.resolve(Dependency.self)!
    }
}
