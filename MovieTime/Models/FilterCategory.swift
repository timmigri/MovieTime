//
//  FilterCategory.swift
//  MovieTime
//
//  Created by Артём Грищенко on 12.05.2023.
//

import Foundation

struct FilterCategory: Identifiable {
    var id: String { pictureName }
    let pictureName: String
    let name: String
    let searchKey: String
    var isChoosed: Bool = false
}
