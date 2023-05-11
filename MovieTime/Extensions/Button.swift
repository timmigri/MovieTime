//
//  Button.swift
//  MovieTime
//
//  Created by Артём Грищенко on 11.05.2023.
//

import Foundation
import SwiftUI

extension Button {
    func mainStyle() -> some View {
        return self
            .foregroundColor(.appTextWhite)
            .font(.sf(.regular, size: 14))
    }
}
