//
//  MovieEntity.swift
//  MovieTime
//
//  Created by Артём Грищенко on 31.05.2023.
//

import Foundation
import RealmSwift

class MovieEntity: Object, Identifiable {
    @Persisted var image: Data?
    @Persisted var kpId: Int
    @Persisted var name: String
    @Persisted var year: Int?
    @Persisted var movieLength: Int?
    @Persisted var seriesLength: Int?
    @Persisted var seriesSeasonsCount: Int?
    @Persisted var movieDescription: String?
    @Persisted var rating: Float
}
