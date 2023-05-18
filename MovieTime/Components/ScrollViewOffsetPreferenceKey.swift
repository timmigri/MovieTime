//
//  ScrollViewOffsetPreferenceKey.swift
//  MovieTime
//
//  Created by Артём Грищенко on 16.05.2023.
//

import SwiftUI

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
