//
//  FavoriteScreenView.swift
//  MovieTime
//
//  Created by Артём Грищенко on 12.05.2023.
//

import SwiftUI

struct BookmarkScreenView: View {
    @ObservedObject var viewModel = Injection.shared.container.resolve(BookmarkViewModel.self)!
    @FocusState private var searchFieldFocused: Bool

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            if !viewModel.showResults {
                PictureBox(
                    pictureName: "Pictures/Bookmark",
                    headlineText: "Список закладок пуст",
                    bodyText: "Добавляйте любимые фильмы в избранное, чтобы видеть их всех в одном месте даже без доступа к Интернету."
                )
                .padding()
            } else {
                VStack {
                    HStack(spacing: 7) {
                        Image("Icons/Search")
                            .padding(.leading, 10)
                            .padding(.vertical, 10)
                            .animation(.easeInOut, value: 5)
                            .onTapGesture {
                                viewModel.onChangeSearchOptions()
                            }
                        TextField(text: $viewModel.query) {
                            Text("Поиск фильмов в избранном...")
                                .foregroundColor(.appSecondary300.opacity(0.5))
                                .bodyText3()
                        }
                        .frame(height: 44)
                        .accentColor(.appPrimary)
                        .foregroundColor(.appSecondary300)
                        .autocorrectionDisabled(true)
                        .focused($searchFieldFocused)
                        .onChange(of: searchFieldFocused) { isFocused in
                            searchFieldFocused = isFocused
                        }
                        .onChange(of: viewModel.query) { _ in
                            viewModel.onChangeSearchOptions()
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(
                                searchFieldFocused ? Color.appPrimary : Color.appSecondary300,
                                lineWidth: 1
                            )
                    )
                    GeometryReader { geometry in
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                                ForEach(viewModel.movieList) { movie in
                                    NavigationLink(destination: MovieScreenView(
                                        source: .database(movie: movie)
                                    )) {
                                        MovieCard(movie: MovieModel(movieDetailModel: movie), geometry: geometry)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top, 32)
                }
                .padding()
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
