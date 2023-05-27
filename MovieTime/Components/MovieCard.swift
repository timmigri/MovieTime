//
//  MovieCard.swift
//  MovieTime
//
//  Created by Артём Грищенко on 28.05.2023.
//

import Foundation
import SwiftUI

struct MovieCard: View {
    let movie: MovieModel
    let geometry: GeometryProxy

    var body: some View {
        VStack(alignment: .leading) {
            if let posterUrl = movie.posterUrl, let movieUrl = URL(string: posterUrl) {
                AsyncImage(
                     url: movieUrl,
                     placeholder: {
                         LoadingIndicator()
                         .frame(maxWidth: .infinity, alignment: .center)
                     },
                     image: {
                         Image(uiImage: $0)
                             .resizable()
                     }
                )
                .frame(maxHeight: (geometry.size.width - 20) / 2 * (3 / 2))
            } else {
                Image(systemName: "camera")
                    .font(.system(size: 40))
                    .foregroundColor(.appSecondary300)
                    .background(Color.appSecondary)
            }
            Text(movie.name)
                .bodyText3()
                .foregroundColor(.appTextWhite)
                .multilineTextAlignment(.leading)
            Spacer()
            HStack {
                if let duration = movie.durationString {
                    Text(duration)
                        .caption2()
                        .foregroundColor(.appTextBlack)
                }
                Spacer()
                HStack(spacing: 2) {
                    Image("Icons/MovieStar")
                    Text(movie.formattedRatingString)
                        .bodyText5()
                        .foregroundColor(.appTextWhite)
                }
            }
        }
    }
}
