//
//  MovieRatingEntity.swift
//  MovieTime
//
//  Created by Артём Грищенко on 31.05.2023.
//

import Foundation
import RealmSwift

class MovieRatingEntity: Object {
    @Persisted var kpMovieId: Int
    @Persisted var rating: Int
}
