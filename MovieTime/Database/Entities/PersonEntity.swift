//
//  PersonEntity.swift
//  MovieTime
//
//  Created by Артём Грищенко on 01.06.2023.
//

import Foundation
import RealmSwift

class PersonEntity: Object {
    @Persisted var kpId: Int
    @Persisted var name: String
    @Persisted var photoUrl: String?
    @Persisted(originProperty: "actors") var movies: LinkingObjects<MovieEntity>
}
