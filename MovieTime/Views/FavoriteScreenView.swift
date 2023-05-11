//
//  FavoriteScreenView.swift
//  MovieTime
//
//  Created by Артём Грищенко on 12.05.2023.
//

import SwiftUI

struct FavoriteScreenView: View {
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            Text("Favorite Screen")
                .foregroundColor(.appText)
        }
    }
}

struct FavoriteScreenView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteScreenView()
    }
}
