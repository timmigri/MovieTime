//
//  StringFormatter.swift
//  MovieTime
//
//  Created by Артём Грищенко on 31.05.2023.
//

import Foundation

struct StringFormatter {
    static func convertLengthToHoursAndMinutesString(_ length: Int) -> String {
        let hoursString = length >= 60 ? String(length / 60) + " ч " : ""
        let minutesString = String(length % 60) + " м"
        return hoursString + minutesString
    }

    static func getMovieDurationString(_ movie: MovieModel) -> String? {
        if let movieLength = movie.movieLength {
            return convertLengthToHoursAndMinutesString(movieLength)
        }
        if let movieDetail = movie as? MovieDetailModel {
            if let seriesSeasonsCount = movieDetail.seriesSeasonsCount, seriesSeasonsCount > 0 {
                return "сезонов: \(seriesSeasonsCount)"
            }
            if let seriesLength = movieDetail.seriesLength {
                return "серия ~ \(convertLengthToHoursAndMinutesString(seriesLength))"
            }
        }
        if let year = movie.year {
            return "\(year) г"
        }
        return nil
    }

    static func getFormattedMovieRatingString(_ rating: Float) -> String {
        String(format: "%.1f", rating)
    }

    static func getMovieGenresString(_ genres: [String]) -> String {
        genres.prefix(3).joined(separator: ", ")
    }
}
