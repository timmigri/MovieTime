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
            .lineSpacing(16 - 12)
    }

    func heading2() -> some View {
        return self
            .font(.sf(.bold, size: 24))
            .lineSpacing(32 - 24)
    }

    func heading3() -> some View {
        return self
            .font(.sf(.bold, size: 20))
            .lineSpacing(26 - 20)
    }

    func bodyText() -> some View {
        return self
            .font(.sf(.regular, size: 18))
            .lineSpacing(22 - 18)
    }

    func bodyText2() -> some View {
        return self
            .font(.sf(.bold, size: 18))
            .lineSpacing(22 - 18)
    }

    func bodyText3() -> some View {
        return self
            .font(.sf(.regular, size: 16))
            .lineSpacing(20 - 16)
    }

    func bodyText4() -> some View {
        return self
            .font(.sf(.bold, size: 16))
            .lineSpacing(20 - 16)
    }

    func bodyText5() -> some View {
        return self
            .font(.sf(.regular, size: 14))
            .lineSpacing(20 - 14)
    }
}
