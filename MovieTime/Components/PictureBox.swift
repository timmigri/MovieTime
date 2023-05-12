//
//  PictureBox.swift
//  MovieTime
//
//  Created by Артём Грищенко on 13.05.2023.
//

import SwiftUI

struct PictureBox: View {
    let pictureName: String
    let headlineText: String
    let bodyText: String

    var body: some View {
        VStack {
            Image(pictureName)
                .padding(.bottom, 30)
            Text(headlineText)
                .heading2()
                .multilineTextAlignment(.center)
                .foregroundColor(.appTextWhite)
                .padding(.bottom, 10)
            Text(bodyText)
                .bodyText5()
                .foregroundColor(.appTextBlack)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
        }
        .frame(maxHeight: .infinity)
    }
}

struct PictureBox_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            PictureBox(pictureName: "LoginIcon", headlineText: "Login", bodyText: "Login")
        }
    }
}
