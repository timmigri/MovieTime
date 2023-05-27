//
//  FavoriteScreenView.swift
//  MovieTime
//
//  Created by Артём Грищенко on 12.05.2023.
//

import SwiftUI

struct BookmarkScreenView: View {
    @ObservedObject var viewModel = Injection.shared.container.resolve(BookmarkViewModel.self)!
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            if viewModel.movieList.count == 0 {
                PictureBox(
                    pictureName: "Pictures/Bookmark",
                    headlineText: "Список закладок пуст",
                    bodyText: "Добавляйте любимые фильмы в закладки, чтобы видеть их всех в одном месте даже без доступа к Интернету."
                )
                .padding()
            } else {
                GeometryReader { geometry in
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                            ForEach(viewModel.movieList) { movie in
                                NavigationLink(destination: MovieScreenView(
                                    id: movie.id
                                )) {
                                    MovieCard(movie: MovieModel(movieDetailModel: movie), geometry: geometry)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.getMovieListFromDB()
        }
    }
}

struct BookmarkScreenView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkScreenView()
    }
}
