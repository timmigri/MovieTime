//
//  LoginScreenView.swift
//  MovieTime
//
//  Created by Артём Грищенко on 11.05.2023.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct LoginScreenView: View {
    @ObservedObject var authViewModel = Injection.shared.container.resolve(AuthViewModel.self)!
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            VStack {
                PictureBox(
                    pictureName: "Pictures/Login",
                    headlineText: "Вход в MovieTime",
                    bodyText: "Войдите в MovieTime, чтобы узнать много нового о мире фильмов и сериалов."
                )
                GoogleSignInButton(action: signIn)
                CustomButton(action: { }, title: "Войти с помощью")
            }
            .padding()
        }
    }

    func signIn() {
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        authViewModel.login(rootViewController: rootViewController)
    }
}

struct LoginScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreenView()
    }
}
