//
//  ActorCard.swift
//  MovieTime
//
//  Created by Артём Грищенко on 19.05.2023.
//

import Foundation
import SwiftUI

struct PersonCard: View {
    let person: PersonModel
    let width: CGFloat

    var body: some View {
        VStack {
            if let photo = person.photoUrl, let photoUrl = URL(string: photo) {
                AsyncImage(
                     url: photoUrl,
                     placeholder: { LoadingIndicator() },
                     image: {
                         Image(uiImage: $0)
                             .resizable()
                     })
                .frame(width: width, height: 3 / 2 * width)
            } else {
                let ratio: CGFloat = 3 / 2
                ZStack {
                    Color.appSecondary
                    Image(systemName: "camera")
                        .font(.system(size: 40))
                        .foregroundColor(.appSecondary300)
                }
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
