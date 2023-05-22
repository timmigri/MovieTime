//
//  AuthViewModel.swift
//  MovieTime
//
//  Created by Артём Грищенко on 22.05.2023.
//

import Foundation
import GoogleSignIn

class AuthViewModel: ObservableObject {
    @Published var authUser: AuthProviderProtocol?

    var isUserLoggedIn: Bool {
        authUser != nil
    }
    
    func login(rootViewController: UIViewController) {
        let googleAuthProvider = GoogleAuthProvider()
        googleAuthProvider.login(rootViewController: rootViewController) { res in
            if (res) { self.authUser = googleAuthProvider }
        }
    }

    func logout() {
        guard let provider = authUser else { return }
        provider.logout()
        authUser = nil
    }

    func restoreAuth() {
        let googleAuthProvider = GoogleAuthProvider()
        googleAuthProvider.restoreAuth { res in
            if res { self.authUser = googleAuthProvider }
        }
    }
}

protocol AuthProviderProtocol {
    func login(rootViewController: UIViewController, completion: @escaping (Bool) -> Void)
    func logout()
    func restoreAuth(completion: @escaping (Bool) -> Void)
}

class GoogleAuthProvider: AuthProviderProtocol {
    var user: GIDGoogleUser?

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
