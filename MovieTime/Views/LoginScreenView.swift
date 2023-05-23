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
                HStack(spacing: 15) {
                    GoogleSignInButton(
                        style: .icon,
                        action: { login(.google) })
                    .clipShape(Circle())
                    
                    Circle()
                        .fill(.blue)
                        .frame(width: 40, height: 40)
                        .sheet(isPresented: $authViewModel.isShowingAuthVK) {
                            authViewModel.vkAuthWebView
                        }
                }
//                CustomButton(action: { login(.vkontakte) }, title: "Войти с помощью")
//                    .sheet(isPresented: $authViewModel.isShowingAuthVK) {
//                        authViewModel.vkAuthWebView
//                    }
            }
            .padding()
        }
    }

    private func login(_ source: AuthViewModel.LoginSource) {
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        authViewModel.login(rootViewController: rootViewController, source)
    }
}

struct LoginScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreenView()
    }
}
