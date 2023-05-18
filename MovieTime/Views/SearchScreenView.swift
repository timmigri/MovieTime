//
//  SearchScreenView.swift
//  MovieTime
//
//  Created by Артём Грищенко on 12.05.2023.
//

import SwiftUI

struct SearchScreenView: View {
    @State private var searchFieldFocused = false
    @ObservedObject var searchViewModel = Injection.shared.container.resolve(SearchViewModel.self)!


    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackground.ignoresSafeArea()
            VStack {
                HStack(spacing: 7) {
                    Image("SearchIcon")
                        .padding(.leading, 10)
                        .padding(.vertical, 10)
                        .animation(.easeInOut, value: 5)
                        .onTapGesture {
                            searchViewModel.onChangeSearchOptions()
                        }
                    TextField("Search for Movies, Series", text: $searchViewModel.query) {
                        searchFieldFocused = $0
                    }
                    .frame(height: 44)
                    .accentColor(.appPrimary)
                    .foregroundColor(.appSecondary300)
                    .onChange(of: searchViewModel.query) { _ in
                        searchViewModel.onChangeSearchOptions()
                    }
                    NavigationLink(destination: FilterScreenView()) {
                        Image("FilterIcon")
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
                if (searchViewModel.showMoviesSection || true) {
                    GeometryReader { geometry in
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack {
                                actorsSection(geometry)
                                moviesSection(geometry)
                                if (searchViewModel.isLoadingMovies) {
                                    LoadingIndicator()
                                        .padding(.top, 20)
                                }
                            }
                        }
                        
                    }
                    .padding(.top, 32)
                }
                
                
                if (searchViewModel.showSearchPicture && false) {
                    PictureBox(
                        pictureName: "SearchPicture",
                        headlineText: "Search in MovieTime",
                        bodyText: "By typing in search box, MovieTime search in movies, series and actors then show you the best results."
                    )
                }
                
                if (searchViewModel.showNoResultPicture) {
                    PictureBox(
                        pictureName: "NoResultPicture",
                        headlineText: "No result",
                        bodyText: "No results found, Please try other words"
                    )
                }
            }
            .padding()
        }
    }

    func actorsSection(_ geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading) {
            Text("Actors")
                .bodyText4()
                .foregroundColor(.appTextWhite)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .center, spacing: 10) {
                    ForEach(searchViewModel.actors) { person in
                        testActor(person, geometry)
                    }
                    if searchViewModel.isLoadingActors {
                        LoadingIndicator()
                    }
                }

            }
        }
    }

    func moviesSection(_ geometry: GeometryProxy) -> some View {
        return VStack(alignment: .leading) {
            Text("Movies & Series")
                .bodyText4()
                .foregroundColor(.appTextWhite)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(searchViewModel.movies) { movie in
                    renderMovie(movie, geometry)
                }
            }
        }
    }

    func testActor(_ person: ActorModel, _ geometry: GeometryProxy) -> some View {
        let width = (geometry.size.width) / 4
        return VStack {
            if let photo = person.photo, let photoUrl = URL(string: photo) {
                AsyncImage(url: photoUrl) { image in
                    image.resizable()
                } placeholder: {
                    LoadingIndicator()
                }
                .frame(width: width, height: 3 / 2 * width)
            } else {
                Color.appSecondary
                    .overlay(
                        Image(systemName: "camera")
                            .font(.system(size: 40))
                            .foregroundColor(.appSecondary300)
                    )
                    .frame(width: width)
                    .frame(height: 3 / 2 * width)
            }
            Text(person.name)
                .caption2()
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(2)
                .foregroundColor(.appSecondary300)
                .multilineTextAlignment(.center)
                .padding(.bottom, 30)
        }
        .frame(maxWidth: width, alignment: .top)
        .onAppear {
            if person.id == searchViewModel.actors.last?.id {
                print("load new")
                searchViewModel.loadActors()
            }
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
                    }
                    .frame(maxHeight: (geometry.size.width - 20) / 2 * (3 / 2))
                }
                Text(movie.name)
                    .bodyText3()
                    .foregroundColor(.appTextWhite)
                Spacer()
                HStack {
                    Text(movie.durationString)
                        .caption2()
                        .foregroundColor(.appTextBlack)
                    Spacer()
                    HStack(spacing: 2) {
                        Image("StarIcon")
                        Text(movie.formattedRatingString)
                            .bodyText5()
                            .foregroundColor(.appTextWhite)
                    }
                }
            }
            .onAppear {
                if movie.id == searchViewModel.movies.last?.id {
                    searchViewModel.loadMovies()
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
