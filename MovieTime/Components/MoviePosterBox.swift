//
//  MoviePosterBox.swift
//  MovieTime
//
//  Created by Артём Грищенко on 01.06.2023.
//

import Foundation
import SwiftUI

struct MoviePosterBox: View {
    let name: String
    let year: Int?
    let rating: Float?
    let genres: [GenreModel]
    let durationString: String?
    var posterView: AnyView
    let geometry: GeometryProxy

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            posterView
            VStack(alignment: .leading) {
                Text(name)
                    .heading3()
                    .foregroundColor(.appTextWhite)
                    .padding(.bottom, 3)
                    .lineLimit(2)
                HStack {
                    if let year {
                        Text(String(year))
                            .caption2()
                        Circle()
                            .fill(Color.appSecondary300)
                            .frame(width: 4, height: 4)
                    }
                    if genres.count > 0 {
                        Text(StringFormatter.getMovieGenresString(genres.map { $0.name }))
                            .caption2()
                    } else {
                        Text("без жанров")
                            .caption2()
                    }
                    if let durationString {
                        Circle()
                            .fill(Color.appSecondary300)
                            .frame(width: 4, height: 4)
                        Text(durationString)
                            .caption2()
                    }
                }
                .foregroundColor(.appSecondary300)
                if let rating {
                    HStack(spacing: 2) {
                        Image(R.image.icons.movieStar)
                        Text(StringFormatter.getFormattedMovieRatingString(rating))
                            .bodyText5()
                            .foregroundColor(.appTextWhite)
                    }
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                Color.appBackground.opacity(0.75)
            )
        }
        .frame(maxWidth: geometry.size.width, alignment: .leading)
        .frame(height: geometry.size.height * 0.7, alignment: .bottom)
    }
}

struct MoviePosterBox_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            GeometryReader { geometry in
                MoviePosterBox(
                    name: "Фильм",
                    year: 2000,
                    rating: 7.8,
                    genres: [],
                    durationString: nil,
                    posterView: AnyView(EmptyView()),
                    geometry: geometry
                )
            }
        }
    }
}
