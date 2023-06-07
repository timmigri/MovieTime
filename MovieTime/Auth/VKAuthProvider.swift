//
//  VKAuthProvider.swift
//  MovieTime
//
//  Created by Артём Грищенко on 07.06.2023.
//

import Foundation
import UIKit

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
