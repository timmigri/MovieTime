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
            if (viewModel.isLoadingMovie) {
                LoadingIndicator()
                    .frame(maxHeight: .infinity)
            }
            if (!viewModel.isLoadingMovie && viewModel.movie == nil) {
                VStack {
                    PictureBox(
                        pictureName: "NoResultPicture",
                        headlineText: "No result",
                        bodyText: "No results found, Please try again"
                    )
                }
            }
            if !viewModel.isLoadingMovie && viewModel.movie != nil {
                let movie = viewModel.movie!
                GeometryReader { geometry in
                    ScrollView {
                        VStack(alignment: .leading) {
                            ZStack(alignment: .bottomLeading) {
                                AsyncImage(url: URL(string: movie.posterUrl)!) { image in
                                    image.resizable()
                                } placeholder: { }
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
                                        Circle()
                                            .fill(Color.appSecondary300)
                                            .frame(width: 4, height: 4)
                                        Text(movie.durationString)
                                            .caption2()
                                    }
                                    .foregroundColor(.appSecondary300)
                                    HStack(spacing: 2) {
                                        Image("StarIcon")
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
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: geometry.size.height * 0.6, alignment: .bottom)
                            Group {
                                descriptionView
                                renderActorsView(geometry)
                                ratingView
                                factsView
                            }
                            .padding(.horizontal)
                            
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
            GeometryReader { geometry in
                if (viewModel.showAdvancedTopBar(geometry.size.height)) {
                    HStack {
                        Image("ArrowBackIcon")
                            .background(
                                Circle()
                                    .fill(Color.appBackground)
                                    .frame(width: 45, height: 45)
                            )
                            .onTapGesture {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        Spacer()
                        Image("BookmarkIcon")
                            .background(
                                Circle()
                                    .fill(Color.appBackground)
                                    .frame(width: 45, height: 45)
                            )
                    }
                    .padding(.horizontal, 20)
                } else {
                    CustomNavigationBar(
                        onTapGesture: { },
                        title: viewModel.movie?.name
                    )
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.loadMovie()
        }
    }

    var ratingView: some View {
        SectionView(title: "Rate", paddingTop: 5, innerContent: AnyView(
            RatingStars(
                rating: viewModel.userRating,
                onChange: viewModel.onChangeRating
            )
        ))
    }

    var descriptionView: some View {
        SectionView(title: "Story", innerContent: AnyView(
            Text(viewModel.movie!.description)
                .bodyText3()
                .foregroundColor(.appTextBlack)
        ))
    }

    func renderActorsView(_ geometry: GeometryProxy) -> some View {
        return SectionView(title: "Actors", innerContent: AnyView(
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
                SectionView(title: "Facts", innerContent: AnyView(
                    ForEach(facts.indices) { index in
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

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .bodyText2()
                .foregroundColor(.appTextWhite)
                .padding(.bottom, 8)
            innerContent
        }
        .padding(.top, paddingTop)
    }
}
