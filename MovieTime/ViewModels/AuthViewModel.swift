//
//  AuthViewModel.swift
//  MovieTime
//
//  Created by Артём Грищенко on 22.05.2023.
//

import Foundation
import GoogleSignIn
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

protocol AuthProviderProtocol {
    func login(rootViewController: UIViewController, completion: @escaping (Bool) -> Void)
    func logout()
    func restoreAuth(completion: @escaping (Bool) -> Void)
}

class GoogleAuthProvider: AuthProviderProtocol {
    private var user: GIDGoogleUser?

    func login(rootViewController: UIViewController, completion: @escaping (Bool) -> Void) {
        GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController) { signInResult, _ in
                self.user = signInResult?.user
                completion(self.user != nil)
        }
    }

    func logout() {
        user = nil
        GIDSignIn.sharedInstance.signOut()
    }

    func restoreAuth(completion: @escaping (Bool) -> Void) {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, _ in
            self.user = user
            completion(user != nil)
        }
    }
}

class VKAuthProvider: AuthProviderProtocol {
    private let storageKey = "vk_auth_token"
    private var token: String?

    func login(rootViewController: UIViewController, completion: @escaping (Bool) -> Void) {
        guard let token else {
            completion(false)
            return
        }
        WebCacheCleaner.clean()
        UserDefaults.standard.setValue(token, forKey: storageKey)
        completion(true)
    }

    func setToken(_ token: String) {
        self.token = token
    }

    func logout() {
        token = nil
        UserDefaults.standard.removeObject(forKey: storageKey)
    }

    func restoreAuth(completion: @escaping (Bool) -> Void) {
        let token = UserDefaults.standard.string(forKey: storageKey)
        self.token = token
        completion(token != nil)
    }
}

struct VKAuthWebView: UIViewRepresentable {
    var authCompletion: (String) -> Void

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AppConfig.vkAppId),
            URLQueryItem(name: "redirect_uri", value: "http://oauth.vk.com/blank.html"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "response_type", value: "token")
        ]

        let urlRequest = URLRequest(url: urlComponents.url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        webView.load(urlRequest)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {

    }

    func makeCoordinator() -> WebViewCoordinator {
        return WebViewCoordinator(authCompletion: authCompletion)
    }

    typealias UIViewType = WKWebView
}

class WebViewCoordinator: NSObject, WKNavigationDelegate {
    var authCompletion: (String) -> Void

    init(authCompletion: @escaping (String) -> Void) {
        self.authCompletion = authCompletion
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }

        let params = fragment.components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String:String]()) { res, param in
                var dict = res
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }

        if let accessToken = params["access_token"] {
            authCompletion(accessToken)
        }
        decisionHandler(.cancel)
    }
}

final class WebCacheCleaner {

    static func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        print("[WebCacheCleaner] All cookies deleted")

        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }

}
