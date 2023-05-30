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
                        pictureName: "Pictures/NoResult",
                        headlineText: "Ничего:(",
                        bodyText: "Произошла ошибка со стороны сервера, из-за которой не возможно показать фильм."
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
                        let offset = innerGeometry.frame(in: .named("scroll")).minY
                        Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: -offset)
                    }
                )
            }
            .ignoresSafeArea()
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                viewModel.onUpdateScrollPosition(value)
            }
        }
    }

    func renderPosterPicture(_ movie: MovieDetailModel) -> some View {
        Group {
            if case .database = viewModel.source, let posterImage = movie.posterImage, let uiImage = UIImage(data: posterImage) {
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
                    Text(movie.genresString)
                        .caption2()
                    if let duration = movie.durationString {
                        Circle()
                            .fill(Color.appSecondary300)
                            .frame(width: 4, height: 4)
                        Text(duration)
                            .caption2()
                    }
                }
                .foregroundColor(.appSecondary300)
                HStack(spacing: 2) {
                    Image("Icons/MovieStar")
                    Text(movie.formattedRatingString)
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
            renderButton(icon: "Icons/ArrowBack")
                .padding(.leading, 8)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Spacer()
            HStack(spacing: 20) {
                if viewModel.showBookmarkButton {
                    renderButton(icon: viewModel.isBookmarked ? "Icons/BookmarkActive" : "Icons/BookmarkMovie")
                        .scaleEffect(viewModel.bookmarkButtonScale)
                        .onTapGesture(perform: viewModel.onTapBookmarkButton)
                }
                renderButton(icon: "Icons/Share")
                    .onTapGesture(perform: shareMovie)
            }
        }
    }

    var ratingView: some View {
        SectionView(title: "Ваша оценка", paddingTop: 5, innerContent: AnyView(
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
                    title: "Описание",
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
                    title: "Актеры",
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
                SectionView(title: "Факты", innerContent: AnyView(
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

    private func shareMovie() {
        guard let source = UIApplication.shared.windows.last?.rootViewController else { return }
        viewModel.shareMovie(source: source)
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
