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

    init(id: Int) {
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(id: id))
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackground.ignoresSafeArea()
            LoadingIndicator(condition: viewModel.isLoadingMovie)
                .frame(maxHeight: .infinity)
            if viewModel.showNoResultPicture {
                VStack {
                    PictureBox(
                        pictureName: "Pictures/NoResult",
                        headlineText: "Ничего:(",
                        bodyText: "Произошла ошибка со стороны сервера, из-за которой не возможно показать фильм."
                    )
                }
            }
            if viewModel.showMovieContent {
                movieContentView
            }
            GeometryReader { geometry in
                if viewModel.showAdvancedTopBar(geometry.size.height) {
                    advancedTopBarView
                } else {
                    CustomNavigationBar(
                        onTapGesture: { },
                        title: viewModel.movie?.name
                    )
                }
            }
            .padding(.horizontal)
        }
        .navigationBarHidden(true)
        .onAppear(perform: viewModel.loadMovie)
    }

    var movieContentView: some View {
        return GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading) {
                    topImageBlockView
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: geometry.size.height * 0.7, alignment: .bottom)
                    Group {
                        descriptionView
                        renderActorsView(geometry)
                        ratingView
                        factsView
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

    var topImageBlockView: some View {
        let movie = viewModel.movie!

        return ZStack(alignment: .bottomLeading) {
            AsyncImage(
                 url: URL(string: movie.posterUrl)!,
                 placeholder: { LoadingIndicator() },
                 image: {
                     Image(uiImage: $0)
                         .resizable()
                 })
            VStack(alignment: .leading) {
                Text(movie.name)
                    .heading3()
                    .foregroundColor(.appTextWhite)
                    .padding(.bottom, 3)
                HStack {
                    Text(String(movie.year))
                        .caption2()
                    Circle()
                        .fill(Color.appSecondary300)
                        .frame(width: 4, height: 4)
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
        HStack {
            Image("Icons/ArrowBack")
                .background(
                    Circle()
                        .fill(Color.appBackground)
                        .frame(width: 45, height: 45)
                )
                .padding(.leading, 8)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Spacer()
            Image("Icons/Bookmark")
                .background(
                    Circle()
                        .fill(Color.appBackground)
                        .frame(width: 45, height: 45)
                )
                .scaleEffect(viewModel.bookmarkButtonScale)
                .onTapGesture(perform: viewModel.onTapBookmarkButton)
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

    var descriptionView: some View {
        SectionView(title: "Описание", innerContent: AnyView(
            Text(viewModel.movie!.description)
                .bodyText3()
                .foregroundColor(.appTextBlack)
        ))
    }

    func renderActorsView(_ geometry: GeometryProxy) -> some View {
        return SectionView(title: "Актеры", innerContent: AnyView(
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 10) {
                    ForEach(viewModel.movie!.actors) { person in
                        PersonCard(
                            person: person,
                            width: geometry.size.width / 4
                        )
                    }
                }
            }
        ))
    }

    var factsView: some View {
        Group {
            if let facts = viewModel.movie!.facts, facts.count > 0 {
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
