//
//  AuthViewModel.swift
//  MovieTime
//
//  Created by Артём Грищенко on 22.05.2023.
//

import Foundation
import WebKit
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var authUser: AuthProviderProtocol?
    @Published var isShowingAuthVK = false {
        willSet {
            if self.isShowingAuthVK { self.isLoadingAuth = false }
        }
    }
    @Published var vkAuthWebView: VKAuthWebView?
    @Published var navigationViewUUID = UUID()
    @Published var isLoadingAuth = false
    @Published var isRestoringAuth = false

    enum LoginSource {
        case vkontakte
        case google
    }

    var isUserLoggedIn: Bool {
        authUser != nil
    }

    func login(_ loginSource: LoginSource) {
        guard let viewController = UIApplication.shared.getCurrentViewController() else { return }
        isLoadingAuth = true
        switch loginSource {
        case .google:
            let googleAuthProvider = GoogleAuthProvider()
            googleAuthProvider.login(rootViewController: viewController) { isSuccess in
                if isSuccess { self.authUser = googleAuthProvider }
                self.isLoadingAuth = false
            }
        case .vkontakte:
            let vkAuthProvider = VKAuthProvider()
            vkAuthWebView = VKAuthWebView { token in
                vkAuthProvider.setToken(token)
                vkAuthProvider.login(rootViewController: viewController) { isSuccess in
                    if isSuccess { self.authUser = vkAuthProvider }
                    self.isShowingAuthVK = false
                    self.isLoadingAuth = false
                }
            }
            isShowingAuthVK = true
        }
    }

    func logout() {
        guard let provider = authUser else { return }
        provider.logout()
        authUser = nil
        AuthInjection.shared.clearContainer()
        navigationViewUUID = UUID()
    }

    func restoreAuth() {
        isRestoringAuth = true
        var providers = [AuthProviderProtocol]()
        var counter = 0
        providers.append(GoogleAuthProvider())
        providers.append(VKAuthProvider())

        for provider in providers {
            provider.restoreAuth { isSuccess in
                counter += 1
                guard self.authUser == nil else { return }
                if isSuccess {
                    self.authUser = provider
                    self.isRestoringAuth = false
                } else if counter == providers.count {
                    self.isRestoringAuth = false
                }
            }
        }
    }
}
