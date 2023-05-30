//
//  SearchScreenView.swift
//  MovieTime
//
//  Created by Артём Грищенко on 12.05.2023.
//

import SwiftUI

struct SearchScreenView: View {
    @FocusState private var searchFieldFocused: Bool
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
                    TextField(text: $viewModel.query) {
                        Text("Поиск фильмов, сериалов, актеров...")
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
                Group {
                    switch viewModel.screenState {
                    case .noResultPicture:
                        PictureBox(
                            pictureName: "Pictures/NoResult",
                            headlineText: "Ничего:(",
                            bodyText: "Ничего не найдено, попробуйте другие слова."
                        )
                    case .searchPicture:
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
                        }
                        .frame(maxHeight: .infinity)
                    case .results:
                        GeometryReader { geometry in
                            ScrollView(.vertical, showsIndicators: false) {
                                VStack {
                                    actorsSection(geometry)
                                    if viewModel.showMoviesSection {
                                        moviesSection(geometry)
                                    }
                                }
                            }
                        }
                        .padding(.top, 32)
                    }
                }
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
            .padding()
        }
    }

    func actorsSection(_ geometry: GeometryProxy) -> some View {
        Group {
            if let error = viewModel.personsLoadingError {
                Text(error)
                    .bodyText3()
                    .foregroundColor(.appPrimary200)
                    .padding(.bottom, 10)
            } else if viewModel.showPersonsList {
                VStack(alignment: .leading) {
                    Text("Персоны")
                        .bodyText2()
                        .foregroundColor(.appTextWhite)
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(alignment: .top, spacing: 10) {
                            ForEach(viewModel.persons) { person in
                                PersonCard(
                                    person: person,
                                    width: geometry.size.width / 4
                                )
                                .onAppear {
                                    if person.id == viewModel.persons.last?.id {
                                        viewModel.loadPersons()
                                    }
                                }
                            }
                            LoadingIndicator(condition: viewModel.isLoadingPersons)
                        }
                    }
                }
                .padding(.bottom, 10)
            }
        }
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
