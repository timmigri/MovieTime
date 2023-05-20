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
    @State var scales = Array(repeating: CGFloat(1), count: 11)

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

    var isAnimationInProgress: Bool {
        scales.filter { $0 != 1 }.count > 0
    }

    func onChangeAnimated(_ value: Int) {
        if isAnimationInProgress { return }
        for index in scales.indices { scales[index] = 1 }
        let totalDuration: CGFloat = 0.7
        onChange(value)
        for index in 1...scales.count {
            let after = totalDuration * CGFloat(index) / CGFloat(scales.count)
            DispatchQueue.main.asyncAfter(deadline: .now() + after) {
                withAnimation {
                    if index < scales.count { scales[index] = 1.5 }
                    scales[index - 1] = 1
                }
            }
        }
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
                                onChangeAnimated(0)
                            } else {
                                onChangeAnimated(value)
                            }
                        }
                        .scaleEffect(scales[value])
                    Text(String(value))
                        .font(.sf(.regular, size: 10))
                        .foregroundColor(.appSecondary300)
                }
            }
        }
    }
}
