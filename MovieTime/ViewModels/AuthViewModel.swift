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
    @Published var isShowingAuthVK = false
    @Published var vkAuthWebView: VKAuthWebView?

    enum LoginSource {
        case vkontakte
        case google
    }

    var isUserLoggedIn: Bool {
        authUser != nil
    }
    
    func login(rootViewController: UIViewController, _ loginSource: LoginSource) {
        
        switch loginSource {
        case .google:
            let googleAuthProvider = GoogleAuthProvider()
            googleAuthProvider.login(rootViewController: rootViewController) { isSuccess in
                if isSuccess { self.authUser = googleAuthProvider }
            }
        case .vkontakte:
            let vkAuthProvider = VKAuthProvider()
            vkAuthWebView = VKAuthWebView { token in
                vkAuthProvider.setToken(token)
                vkAuthProvider.login(rootViewController: rootViewController) { isSuccess in
                    if isSuccess { self.authUser = vkAuthProvider }
                }
            }
            isShowingAuthVK = true
        }
    }

    func logout() {
        guard let provider = authUser else { return }
        provider.logout()
        authUser = nil
    }

    func restoreAuth() {
        let googleAuthProvider = GoogleAuthProvider()
        let vkAuthProvider = VKAuthProvider()
        googleAuthProvider.restoreAuth { isSuccess in
            if isSuccess && self.authUser == nil { self.authUser = googleAuthProvider }
        }
        vkAuthProvider.restoreAuth { isSuccess in
            if isSuccess && self.authUser == nil { self.authUser = vkAuthProvider }
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

        let urlRequest = URLRequest(url: urlComponents.url!)
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
