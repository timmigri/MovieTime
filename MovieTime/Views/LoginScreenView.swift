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
                    pictureName: R.image.pictures.login.name,
                    headlineText: R.string.login.welcomeTitle(),
                    bodyText: R.string.login.welcomeText()
                )
                Divider()
                    .frame(height: 2)
                    .frame(maxWidth: .infinity)
                    .overlay(Color.appTextBlack.overlay(Text(R.string.login.buttonSectionText())
                        .foregroundColor(.appTextBlack)
                        .bodyText5()
                        .padding(.horizontal, 10)
                        .background(Color.appBackground)
                    ))
                    .padding(.bottom, 30)
                HStack(spacing: 15) {
                    GoogleSignInButton(
                        style: .icon,
                        action: { login(.google) })
                    .clipShape(Circle())

                    Circle()
                        .fill(Color(red: 81 / 255, green: 129 / 255, blue: 184 / 255))
                        .frame(width: 40, height: 40)
                        .sheet(isPresented: $authViewModel.isShowingAuthVK) {
                            authViewModel.vkAuthWebView
                        }
                        .overlay(
                            Image(R.image.icons.vK)
                        )
                        .onTapGesture {
                            login(.vkontakte)
                        }

                }
            }
            .padding()
            .conditionTransform(authViewModel.isLoadingAuth) { view in
                view.overlay(
                    Color.appBackground.opacity(0.9).overlay(
                        LoadingIndicator()
                    )
                )
            }
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
