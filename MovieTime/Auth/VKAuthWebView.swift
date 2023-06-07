//
//  VKAuthWebView.swift
//  MovieTime
//
//  Created by Артём Грищенко on 07.06.2023.
//

import Foundation
import WebKit
import SwiftUI

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

    func makeCoordinator() -> VKWebViewCoordinator {
        return VKWebViewCoordinator(authCompletion: authCompletion)
    }

    typealias UIViewType = WKWebView
}

class VKWebViewCoordinator: NSObject, WKNavigationDelegate {
    var authCompletion: (String) -> Void

    init(authCompletion: @escaping (String) -> Void) {
        self.authCompletion = authCompletion
    }

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void
    ) {
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }

        let params = fragment.components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { res, param in
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
