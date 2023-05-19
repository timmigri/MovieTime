//
//  LoginScreenView.swift
//  MovieTime
//
//  Created by Артём Грищенко on 11.05.2023.
//

import SwiftUI

struct LoginScreenView: View {
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            VStack {
                PictureBox(
                    pictureName: "Pictures/Login",
                    headlineText: "Вход в MovieTime",
                    bodyText: "Войдите в MovieTime, чтобы узнать много нового о мире фильмов и сериалов."
                )
                CustomButton(action: { }, title: "Войти с помощью")
            }
            .padding()
        }
    }
}

struct LoginScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreenView()
    }
}
