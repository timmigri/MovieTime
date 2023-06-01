//
//  MovieScreenView.swift
//  MovieTime
//
//  Created by Артём Грищенко on 13.05.2023.
//

import SwiftUI

struct MovieScreenView: View {
    @StateObject var viewModel: MovieDetailViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    private let scrollCoordinateSpace = "scroll"

    init(source: MovieDetailViewModel.Source) {
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(source: source))
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackground.ignoresSafeArea()
            switch viewModel.screenState {
            case .loading:
                LoadingIndicator()
                    .frame(maxHeight: .infinity)
            case .success(let movie):
                renderMovieContentView(movie)
            case .error:
                VStack {
                    PictureBox(
                        pictureName: R.image.pictures.noResult.name,
                        headlineText: R.string.movie.noResultTitle(),
                        bodyText: R.string.movie.noResultText()
                    )
                }
            }
            GeometryReader { geometry in
                if viewModel.showAdvancedTopBar(geometry.size.height) {
                    advancedTopBarView
                } else {
                    CustomNavigationBar(
                        onTapGesture: { },
                        title: viewModel.screenState.movie?.name
                    )
                }
            }
            .padding(.horizontal)
        }
        .navigationBarHidden(true)
        .onAppear(perform: viewModel.loadMovie)
    }

    func renderMovieContentView(_ movie: MovieDetailModel) -> some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading) {
                    renderTopImageBlockView(movie)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: geometry.size.height * 0.7, alignment: .bottom)
                    Group {
                        renderDescriptionView(movie)
                        renderActorsView(movie, geometry: geometry)
                        ratingView
                        renderFactsView(movie)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .background(
                    GeometryReader { innerGeometry in
                        let offset = innerGeometry.frame(in: .named(scrollCoordinateSpace)).minY
                        Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: -offset)
                    }
                )
            }
            .ignoresSafeArea()
            .coordinateSpace(name: scrollCoordinateSpace)
            .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                viewModel.onUpdateScrollPosition(value)
            }
        }
    }

    func renderPosterPicture(_ movie: MovieDetailModel) -> some View {
        Group {
            if case .database = viewModel.source,
                let posterImage = movie.posterImage,
                let uiImage = UIImage(data: posterImage) {
                Image(uiImage: uiImage)
                    .resizable()
            } else if case .network = viewModel.source, let url = viewModel.posterUrl {
                AsyncImage(
                    url: url,
                    placeholder: { LoadingIndicator() },
                    image: {
                        Image(uiImage: $0)
                            .resizable()
                    },
                    onFinishLoading: viewModel.onFinishLoadingPoster
                )
            }
        }
    }

    func renderTopImageBlockView(_ movie: MovieDetailModel) -> some View {
        ZStack(alignment: .bottomLeading) {
            renderPosterPicture(movie)
            VStack(alignment: .leading) {
                Text(movie.name)
                    .heading3()
                    .foregroundColor(.appTextWhite)
                    .padding(.bottom, 3)
                HStack {
                    if let year = movie.year {
                        Text(String(year))
                            .caption2()
                        Circle()
                            .fill(Color.appSecondary300)
                            .frame(width: 4, height: 4)
                    }
                    Text(StringFormatter.getMovieGenresString(movie.genres.map { $0.name }))
                        .caption2()
                    if let duration = StringFormatter.getMovieDurationString(movie) {
                        Circle()
                            .fill(Color.appSecondary300)
                            .frame(width: 4, height: 4)
                        Text(duration)
                            .caption2()
                    }
                }
                .foregroundColor(.appSecondary300)
                HStack(spacing: 2) {
                    Image(R.image.icons.movieStar)
                    Text(StringFormatter.getFormattedMovieRatingString(movie.rating))
                        .bodyText5()
                        .foregroundColor(.appTextWhite)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                Color.appBackground.opacity(0.75)
            )
        }
    }

    var advancedTopBarView: some View {
        func renderButton(icon: String) -> some View {
            Image(icon)
                .background(
                    Circle()
                        .fill(Color.appBackground.opacity(0.95))
                        .frame(width: 45, height: 45)
                )
        }

        return HStack {
            renderButton(icon: R.image.icons.arrowBack.name)
                .padding(.leading, 8)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Spacer()
            HStack(spacing: 20) {
                if viewModel.showBookmarkButton {
                    renderButton(
                        icon: viewModel.isBookmarked ?
                        R.image.icons.bookmarkActive.name :
                        R.image.icons.bookmarkMovie.name
                    )
                        .scaleEffect(viewModel.bookmarkButtonScale)
                        .onTapGesture(perform: viewModel.onTapBookmarkButton)
                }
                renderButton(icon: R.image.icons.share.name)
                    .onTapGesture(perform: viewModel.shareMovie)
            }
        }
    }

    var ratingView: some View {
        SectionView(title: R.string.movie.userRatingSectionTitle(), paddingTop: 5, innerContent: AnyView(
            RatingStars(
                rating: viewModel.userRating,
                onChange: viewModel.onChangeRating
            )
        ))
    }

    func renderDescriptionView(_ movie: MovieDetailModel) -> some View {
        Group {
            if let description = movie.description {
                SectionView(
                    title: R.string.movie.descriptionSectionTitle(),
                    innerContent: AnyView(
                    Text(description)
                        .bodyText3()
                        .foregroundColor(.appTextBlack)
                ))
            }
        }
    }

    func renderActorsView(_ movie: MovieDetailModel, geometry: GeometryProxy) -> some View {
        Group {
            if movie.actors.count > 0 {
                SectionView(
                    title: R.string.movie.actorsSectionTitle(),
                    innerContent: AnyView(
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .top, spacing: 10) {
                                ForEach(movie.actors) { person in
                                    PersonCard(
                                        person: person,
                                        width: geometry.size.width / 4
                                    )
                                }
                            }
                        }
                    ))
            }
        }
    }

    func renderFactsView(_ movie: MovieDetailModel) -> some View {
        Group {
            if let facts = movie.facts, facts.count > 0 {
                SectionView(title: R.string.movie.factsSectionTitle(), innerContent: AnyView(
                    ForEach(facts.indices, id: \.self) { index in
                        Text(facts[index])
                            .bodyText5()
                            .foregroundColor(.appTextWhite)
                            .padding(15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.appSecondary)
                    }
                ))
            }
        }
    }
}

private struct SectionView: View {
    let title: String
    var paddingTop: CGFloat = 20.0
    let innerContent: AnyView
    @State var opacity: CGFloat = 0

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .bodyText2()
                .foregroundColor(.appTextWhite)
                .padding(.bottom, 8)
            innerContent
        }
        .padding(.top, paddingTop)
        .opacity(opacity)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    opacity = 1
                }
            }
        }
    }
}
