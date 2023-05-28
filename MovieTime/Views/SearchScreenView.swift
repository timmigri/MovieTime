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
                    .autocorrectionDisabled(true)
                    .onChange(of: viewModel.query) { _ in
                        viewModel.isUserTyping = true
                    }
                    NavigationLink(destination: FilterScreenView()) {
                        let icon = viewModel.isSomeFilterActive ? "Icons/FilterActive" : "Icons/Filter"
                        Image(icon)
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
                                if viewModel.showActorsSection {
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
                    VStack {
                        PictureBox(
                            pictureName: "Pictures/Search",
                            headlineText: "Поиск в MovieTime",
                            bodyText: "Начните набирать в строке поиска, и MovieTime покажет вам лучшие результаты фильмов, сериалов и актеров по вашему запросу. Не знаете, что посмотреть?", // swiftlint:disable:this line_length
                            takeAllSpace: false
                        )
                        NavigationLink(destination: MovieScreenView(
                            source: .network(kpId: nil)
                        )) {
                            Text("Покажи случайный фильм")
                                .bodyText5()
                        }
                    }.frame(maxHeight: .infinity)
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
            source: .network(kpId: movie.id)
        )) {
            MovieCard(movie: movie, geometry: geometry)
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
