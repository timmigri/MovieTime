//
//  UserRatingEntity.swift
//  MovieTime
//
//  Created by Артём Грищенко on 31.05.2023.
//

import Foundation
import RealmSwift

class UserRatingEntity: Object {
    @Persisted var kpMovieId: Int
    @Persisted var rating: Int
}
