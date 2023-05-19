//
//  SearchScreenView.swift
//  MovieTime
//
//  Created by Артём Грищенко on 12.05.2023.
//

import SwiftUI

struct SearchScreenView: View {
    @State private var searchFieldFocused = false
    @ObservedObject var viewModel = Injection.shared.container.resolve(SearchViewModel.self)!

    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackground.ignoresSafeArea()
            VStack {
                HStack(spacing: 7) {
                    Image("Icons/Search")
                        .padding(.leading, 10)
                        .padding(.vertical, 10)
                        .animation(.easeInOut, value: 5)
                        .onTapGesture {
                            viewModel.onChangeSearchOptions()
                        }
                    TextField("Поиск фильмов, сериалов, актеров...", text: $viewModel.query) {
                        searchFieldFocused = $0
                    }
                    .frame(height: 44)
                    .accentColor(.appPrimary)
                    .foregroundColor(.appSecondary300)
                    .onChange(of: viewModel.query) { _ in
                        viewModel.onChangeSearchOptions()
                    }
                    NavigationLink(destination: FilterScreenView()) {
                        Image("Icons/Filter")
                            .padding(.leading, 10)
                            .padding(.vertical, 10)
                            .animation(.easeInOut, value: 5)
                            .padding(.trailing, 10)
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(
                            searchFieldFocused ? Color.appPrimary : Color.appSecondary300, lineWidth: 1
                        )
                )
                if viewModel.showMoviesSection || viewModel.showActorsSection {
                    GeometryReader { geometry in
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack {
                                if (viewModel.showActorsSection) {
                                    actorsSection(geometry)
                                }
                                if viewModel.showMoviesSection {
                                    moviesSection(geometry)
                                }
                            }
                        }
                    }
                    .padding(.top, 32)
                }
                if viewModel.showSearchPicture {
                    PictureBox(
                        pictureName: "Pictures/Search",
                        headlineText: "Поиск в MovieTime",
                        bodyText: "Начните набирать в строке поиска, и MovieTime покажет вам лучшие результаты фильмов, сериалов и актеров по вашему запросу."
                    )
                }
                if viewModel.showNoResultPicture {
                    PictureBox(
                        pictureName: "Pictures/NoResult",
                        headlineText: "Ничего:(",
                        bodyText: "Ничего не найдено, попробуйте другие слова."
                    )
                }
            }
            .padding()
        }
    }

    func actorsSection(_ geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading) {
            Text("Актеры")
                .bodyText2()
                .foregroundColor(.appTextWhite)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 10) {
                    ForEach(viewModel.actors) { person in
                        PersonCard(
                            person: person,
                            width: geometry.size.width / 4
                        )
                        .onAppear {
                            if person.id == viewModel.actors.last?.id {
                                viewModel.loadActors()
                            }
                        }
                    }
                    LoadingIndicator(condition: viewModel.isLoadingActors)
                }

            }
        }
        .padding(.bottom, 10)
    }

    func moviesSection(_ geometry: GeometryProxy) -> some View {
        return VStack(alignment: .leading) {
            Text("Фильмы и сериалы")
                .bodyText2()
                .foregroundColor(.appTextWhite)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(viewModel.movies) { movie in
                    renderMovie(movie, geometry)
                }
            }
            LoadingIndicator(condition: viewModel.isLoadingMovies)
                .frame(maxWidth: .infinity)
        }
    }

    func renderMovie(_ movie: MovieModel, _ geometry: GeometryProxy) -> some View {
        NavigationLink(destination: MovieScreenView(
            id: movie.id
        )) {
            VStack(alignment: .leading) {
                if let movieUrl = URL(string: movie.posterUrl) {
                    AsyncImage(url: movieUrl) { image in
                        image.resizable()
                    } placeholder: {
                        LoadingIndicator()
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(maxHeight: (geometry.size.width - 20) / 2 * (3 / 2))
                }
                Text(movie.name)
                    .bodyText3()
                    .foregroundColor(.appTextWhite)
                    .multilineTextAlignment(.leading)
                Spacer()
                HStack {
                    if let duration = movie.durationString {
                        Text(duration)
                            .caption2()
                            .foregroundColor(.appTextBlack)
                    }
                    Spacer()
                    HStack(spacing: 2) {
                        Image("Icons/MovieStar")
                        Text(movie.formattedRatingString)
                            .bodyText5()
                            .foregroundColor(.appTextWhite)
                    }
                }
            }
            .onAppear {
                if movie.id == viewModel.movies.last?.id {
                    viewModel.loadMovies()
                }
            }
        }
    }
}

struct SearchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreenView()
    }
}
