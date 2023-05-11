//
//  Font.swift
//  MovieTime
//
//  Created by Артём Грищенко on 11.05.2023.
//

import Foundation
import SwiftUI

extension Font {
    enum SFFont: String {
        case regular = "SFProDisplay-Regular"
        case bold = "SFProDisplay-Bold"
    }

    static func sf(_ type: SFFont, size: CGFloat) -> Font {
        return .custom(type.rawValue, size: size)
    }
}
