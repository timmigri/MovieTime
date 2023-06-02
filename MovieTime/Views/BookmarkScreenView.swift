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
            switch viewModel.screenState {
            case .noBookmarkPicture:
                ZStack(alignment: .bottomTrailing) {
                    PictureBox(
                        pictureName: R.image.pictures.bookmark.name,
                        headlineText: R.string.favorite.pictureBoxTitle(),
                        bodyText: R.string.favorite.pictureBoxText()
                    )
                    .padding()
                    createMovieButton
                        .padding(.bottom, 5)
                }
            case .success(let movieList):
                ZStack(alignment: .bottomTrailing) {
                    VStack {
                        filterView
                        GeometryReader { geometry in
                            ScrollView(.vertical, showsIndicators: false) {
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                                    ForEach(movieList, id: \.id) { movie in
                                        NavigationLink(destination: MovieScreenView(
                                            source: .database(kpId: movie.kpId, uuid: movie.uuid)
                                        )) {
                                            MovieCard(movie: movie, geometry: geometry)
                                        }
                                    }
                                }
                            }
                        }
                        .onTapGesture(perform: UIApplication.shared.clearAllTextFieldFocus)
                        .padding(.top, 32)
                    }
                    createMovieButton
                }
                .padding()
            case .error(let error):
                Text(error)
                    .bodyText3()
                    .foregroundColor(.appSecondary300)
            }
        }.onAppear(perform: viewModel.onChangeSearchOptions)
    }
    
    var createMovieButton: some View {
        NavigationLink(destination: CustomMovieScreenView(mode: .create)
        ) {
            ZStack {
                Circle()
                    .fill(Color.appPrimary)
                    .frame(width: 50, height: 50)
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .font(.system(size: 25))
            }
            .padding(10)
            .opacity(0.9)
        }
    }

    var filterView: some View {
        Group {
            HStack(spacing: 7) {
                Image(R.image.icons.search.name)
                    .padding(.leading, 10)
                    .padding(.vertical, 10)
                    .animation(.easeInOut, value: 5)
                    .onTapGesture(perform: viewModel.onChangeSearchOptions)
                TextField(text: $viewModel.query) {
                    Text(R.string.favorite.searchFieldPlaceholder())
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
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(
                        searchFieldFocused ? Color.appPrimary : Color.appSecondary300,
                        lineWidth: 1
                    )
            )
            HStack(spacing: 5) {
                Image(R.image.icons.filter.name)
                CustomSelect(
                    options: viewModel.sortOptions,
                    onSelectOption: viewModel.onSelectSortOption
                )
                Spacer()
                if viewModel.currentSortOptionIndex != nil {
                    sortOrderButton
                }
            }
            .padding(.top, 5)
        }
    }

    var sortOrderButton: some View {
        let iconColor: Color = viewModel.sortOrderAscending ? .white : .appPrimary
        let backgroundColor: Color = viewModel.sortOrderAscending ? .appPrimary : .appPrimary200
        return Image(systemName: "arrow.up.arrow.down")
            .foregroundColor(iconColor)
            .padding(8)
            .background(backgroundColor)
            .onTapGesture(perform: viewModel.onTapSortOrderButton)
    }
}

struct BookmarkScreenView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkScreenView()
    }
}
