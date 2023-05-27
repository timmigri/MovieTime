//
//  MovieDBModel.swift
//  MovieTime
//
//  Created by Артём Грищенко on 28.05.2023.
//

import Foundation
import RealmSwift

class MovieDBModel: Object {
    @Persisted var image: Data?
    @Persisted var kpId: Int
    @Persisted var name: String
    @Persisted var year: Int
    @Persisted var movieLength: Int?
    @Persisted var movieDescription: String?
    @Persisted var rating: Float
}
