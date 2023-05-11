//
//  Text.swift
//  MovieTime
//
//  Created by Артём Грищенко on 11.05.2023.
//

import Foundation
import SwiftUI

extension Text {
    func caption2() -> some View {
        return self
            .font(.sf(.regular, size: 12))
            .lineSpacing(18 - 12)
    }
    
    func heading2() -> some View {
        return self
            .font(.sf(.bold, size: 24))
            .lineSpacing(32 - 24)
    }
    
    func bodyText3() -> some View {
        return self
            .font(.sf(.bold, size: 18))
            .lineSpacing(24 - 18)
    }

    func bodyText5() -> some View {
        return self
            .font(.sf(.regular, size: 14))
            .lineSpacing(20 - 14)
    }
}
