//
//  GenreEntity.swift
//  MovieTime
//
//  Created by Артём Грищенко on 01.06.2023.
//

import Foundation
import RealmSwift

class GenreEntity: Object {
    @Persisted var name: String
}
