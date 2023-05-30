//
//  FilterCategory.swift
//  MovieTime
//
//  Created by Артём Грищенко on 12.05.2023.
//

import Foundation

struct FilterCategoryModel: Identifiable {
    var id: String { name }
    let pictureName: String
    let name: String
    let searchKey: String
    var isSelected: Bool = false
}
