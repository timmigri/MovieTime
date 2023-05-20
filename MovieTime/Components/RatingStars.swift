//
//  RatingStars.swift
//  MovieTime
//
//  Created by Артём Грищенко on 19.05.2023.
//

import SwiftUI

struct RatingStars: View {
    let rating: Int?
    let onChange: (Int) -> Void

    func getImageName(forValue value: Int) -> String {
        if let rating, value <= rating {
            return "star.fill"
        }
        return "star"
    }

    func isSelectedValue(forValue value: Int) -> Bool {
        if let rating {
            return rating == value
        }
        return false
    }

    var body: some View {
        HStack(spacing: 5) {
            ForEach(1..<11) { value in
                VStack {
                    Image(systemName: getImageName(forValue: value))
                        .foregroundColor(.appPrimary)
                        .font(.system(size: 20))
                        .onTapGesture {
                            if let rating, value == rating {
                                onChange(0)
                            } else {
                                onChange(value)
                            }
                        }
                    Text(String(value))
                        .font(.sf(.regular, size: 10))
                        .foregroundColor(.appSecondary300)
                }
            }
        }
    }
}
