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
                if (searchViewModel.isLoadingMovies) {
                    ProgressView()
                        .progressViewStyle(
                            CircularProgressViewStyle(tint: .appPrimary200))
                        .frame(maxHeight: .infinity)
                }
                if (!searchViewModel.isLoadingMovies && searchViewModel.movies.count > 0) {
                    GeometryReader { geometry in
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack {
                                //                            actorsSection(geometry)
                                moviesSection(geometry)
                            }
                        }
                    }
                    .padding(.top, 32)
                    .frame(maxHeight: .infinity)
                }
                
                if (!searchViewModel.isLoadingMovies && searchViewModel.movies.count == 0) {
                    if (searchViewModel.query.count == 0) {
                        PictureBox(
                            pictureName: "SearchPicture",
                            headlineText: "Search in MovieTime",
                            bodyText: "By typing in search box, MovieTime search in movies, series and actors then show you the best results."
                        )
                    } else {
                        PictureBox(
                            pictureName: "NoResultPicture",
                            headlineText: "No result",
                            bodyText: "No results found, Please try other words"
                        )
                    }
                }
            }
            .padding()
        }
        .onAppear {
            searchViewModel.onChangeSearchOptions()
        }
    }

    func actorsSection(_ geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading) {
            Text("Actors")
                .bodyText4()
                .foregroundColor(.appTextWhite)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    testActor(geometry)
                    testActor(geometry)
                    testActor(geometry)
                    testActor(geometry)
                    testActor(geometry)
                    testActor(geometry)
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

    func testActor(_ geometry: GeometryProxy) -> some View {
        let padding: CGFloat = 10
        let width = (geometry.size.width - padding * 4) / 4
        return VStack {
            Image("ActorExample")
                .frame(width: width, height: width)
            Text("Dwayne Johnson")
                .caption2()
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(2)
                .foregroundColor(.appSecondary300)
                .multilineTextAlignment(.center)
                .padding(.bottom, 30)
        }
        .frame(maxWidth: width)
    }

    func renderMovie(_ movie: MovieModel, _ geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading) {
            if let movieUrl = URL(string: movie.posterUrl) {
                AsyncImage(
                    url: movieUrl,
                    placeholder: {
                        ProgressView()
                            .progressViewStyle(
                                CircularProgressViewStyle(tint: .appPrimary200))
                    },
                    image: {
                        Image(uiImage: $0)
                            .resizable()
                        
                    })
                .frame(maxHeight: (geometry.size.width - 20) / 2 * (3 / 2))
            }
            Text(movie.name)
                .bodyText3()
                .foregroundColor(.appTextWhite)
            Spacer()
            HStack {
                Text("4 seasons")
                    .caption2()
                    .foregroundColor(.appTextBlack)
                Spacer()
                HStack(spacing: 2) {
                    Image("StarIcon")
                    Text(String(format: "%.1f", movie.rating))
                        .bodyText5()
                        .foregroundColor(.appTextWhite)
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
