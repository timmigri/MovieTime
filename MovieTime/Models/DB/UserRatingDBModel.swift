//
//  UserRatingDBModel.swift
//  MovieTime
//
//  Created by Артём Грищенко on 27.05.2023.
//

import Foundation
import RealmSwift

class UserRatingDBModel: Object {
    @Persisted var kpMovieId: Int
    @Persisted var rating: Int
}
