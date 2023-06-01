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
    
    @Published var nameField: String = ""
    @Published var descriptionField: String = ""
    @Published var movieLengthField: String = ""
    @Published var selectedYearIndex: Int = 0
    @Published var facts = [String]()
    let availableYears: [Int]
    
    var selectedYear: Int {
        availableYears[selectedYearIndex]
    }
    
    init(mode: Mode) {
        let minYear = 1950
        let currentYear = Calendar(identifier: .gregorian).dateComponents([.year], from: Date()).year ?? 2023
        availableYears = Array(minYear...currentYear)
        selectedYearIndex = availableYears.firstIndex(where: { $0 == 2000 }) ?? availableYears.count / 2
    }
}
