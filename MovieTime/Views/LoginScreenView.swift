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
                    pictureName: "LoginIcon",
                    headlineText: "MovieTime Login",
                    bodyText: "Login to your account to know everything about movie world"
                )
                CustomButton(action: { }, title: "Login with")
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
