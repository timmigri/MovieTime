//
//  GoogleAuthProvider.swift
//  MovieTime
//
//  Created by Артём Грищенко on 07.06.2023.
//

import Foundation
import GoogleSignIn

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
