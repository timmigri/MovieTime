//
//  MovieScreenView.swift
//  MovieTime
//
//  Created by Артём Грищенко on 13.05.2023.
//

import SwiftUI

struct MovieScreenView: View {
    var body: some View {
        ZStack (alignment: .top) {
            GeometryReader { geometry in
                ZStack(alignment: .bottomLeading) {
                    Image("PosterExample")
                        .resizable()
                        .ignoresSafeArea()
                        .overlay(
                            Color.appSecondary300.ignoresSafeArea().opacity(0.2)
                        )
                    VStack(alignment: .leading) {
                        Text("The IT Crowd")
                            .heading3()
                            .foregroundColor(.appTextWhite)
                            .padding(.bottom, 3)
                        HStack {
                            Text("2006")
                                .caption2()
                            Circle()
                                .fill(Color.appSecondary300)
                                .frame(width: 4, height: 4)
                            Text("Sitcom, Sitcom")
                                .caption2()
                            Circle()
                                .fill(Color.appSecondary300)
                                .frame(width: 4, height: 4)
                            Text("5 seasons")
                                .caption2()
                        }
                        .foregroundColor(.appSecondary300)
                        HStack(spacing: 2) {
                            Image("StarIcon")
                            Text("4.1")
                                .bodyText5()
                                .foregroundColor(.appTextWhite)
                        }
                    }
                    .padding(.bottom, 10)
                    .padding(.leading, 10)
                }
                .frame(maxHeight: geometry.size.height * 0.4)
            }
            HStack {
                Image("ArrowBackIcon")
                    .overlay(
                        Circle()
                            .fill(Color.appSecondary300.opacity(0.3))
                            .frame(width: 45, height: 45)
                    )
                Spacer()
                Image("BookmarkIcon")
                    .overlay(
                        Circle()
                            .fill(Color.appSecondary300.opacity(0.3))
                            .frame(width: 45, height: 45)
                    )

            }
            .padding(.horizontal, 20)
        }
    }
}

struct MovieScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MovieScreenView()
    }
}
