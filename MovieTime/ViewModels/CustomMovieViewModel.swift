//
//  CustomMovieViewModel.swift
//  MovieTime
//
//  Created by Артём Грищенко on 01.06.2023.
//

import Foundation
import SwiftUI

class CustomMovieViewModel: ObservableObject {
    enum Mode {
        case create
    }

    @AuthInjected var movieRepository: MovieRepository
    @Published var image: Image?
    @Published var nameField: String = ""
    @Published var descriptionField: String = ""
    @Published var movieLengthField: String = ""
    @Published var selectedYearIndex: Int = 0
    @Published private(set) var selectedGenresIndexes = [Int]()
    let genres = GenreModel.generateBasicGenres()
    let availableYears: [Int]

    var selectedYear: Int {
        availableYears[selectedYearIndex]
    }

    var showCreateButton: Bool {
        nameField.count > 0
    }

    var selectedGenres: [GenreModel] {
        selectedGenresIndexes.map { genres[$0] }
    }

    var movieLengthFormatted: String? {
        guard let duration = Int(movieLengthField) else { return nil }
        return StringFormatter.convertLengthToHoursAndMinutesString(duration)
    }

    init(mode: Mode) {
        let minYear = 1950
        let currentYear = (Calendar(identifier: .gregorian).dateComponents([.year], from: Date()).year ?? 2023) + 7
        availableYears = Array(minYear...currentYear)
        selectedYearIndex = availableYears.firstIndex(where: { $0 == 2000 }) ?? availableYears.count / 2
    }

    func onChangeSelectedGenres(_ indexes: [Int]) {
        selectedGenresIndexes = indexes
    }

    func createMovie(uiImagePoster: UIImage?) {
        _ = self.movieRepository.toggleMovie(movie: constructMovieDetailModel(uiImagePoster: uiImagePoster))
    }

    private func constructMovieDetailModel(uiImagePoster: UIImage?) -> MovieDetailModel {
        return MovieDetailModel(
            kpId: nil,
            uuid: UUID(),
            name: nameField,
            year: selectedYear,
            movieLength: Int(movieLengthField),
            seriesLength: nil,
            seriesSeasonsCount: nil,
            description: descriptionField,
            facts: [],
            genres: selectedGenres,
            posterUrl: nil,
            rating: nil,
            actors: [],
            posterImage: uiImagePoster?.pngData()
        )
    }
}
