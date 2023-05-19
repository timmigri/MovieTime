//
//  ActorCard.swift
//  MovieTime
//
//  Created by Артём Грищенко on 19.05.2023.
//

import Foundation
import SwiftUI

struct PersonCard: View {
    let person: ActorModel
    let width: CGFloat

    var body: some View {
        VStack {
            if let photo = person.photo, let photoUrl = URL(string: photo) {
                AsyncImage(url: photoUrl) { image in
                    image.resizable()
                } placeholder: {
                    LoadingIndicator()
                }
                .frame(width: width, height: 3 / 2 * width)
            } else {
                let ratio: CGFloat = 3 / 2
                Color.appSecondary
                    .overlay(
                        Image(systemName: "camera")
                            .font(.system(size: 40))
                            .foregroundColor(.appSecondary300)
                    )
                    .frame(width: width)
                    .frame(height: ratio * width)
            }
            Text(person.name)
                .caption2()
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(2)
                .foregroundColor(.appSecondary300)
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
        }
        .frame(maxWidth: width, alignment: .top)
    }
}
