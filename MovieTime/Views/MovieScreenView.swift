//
//  MovieScreenView.swift
//  MovieTime
//
//  Created by Артём Грищенко on 13.05.2023.
//

import SwiftUI

struct MovieScreenView: View {
    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackground.ignoresSafeArea()
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading) {
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
                            .padding(.leading, 20)
                        }
                        .frame(maxHeight: geometry.size.height * 0.4)
                        descriptionView
                        ratingView
                        factsView
                        
                    }
                }
                .ignoresSafeArea()
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
    
    var ratingView: some View {
        VStack(alignment: .leading) {
            Text("Rate")
                .bodyText2()
                .foregroundColor(.appTextWhite)
                .padding(.bottom, 8)
            HStack(spacing: 3) {
                Image(systemName: "star.fill")
                    .foregroundColor(.appPrimary)
                    .font(.system(size: 32))
                Image(systemName: "star")
                    .foregroundColor(.appPrimary)
                    .font(.system(size: 32))
            }
        }
        .padding(.horizontal)
        .padding(.top, 20)
    }
    
    var descriptionView: some View {
        VStack(alignment: .leading) {
            Text("Story")
                .bodyText2()
                .foregroundColor(.appTextWhite)
                .padding(.bottom, 8)
            Text("The IT Crowd is a British sitcom originally broadcast by Channel 4, written an")
                .bodyText3()
                .foregroundColor(.appTextBlack)
        }
        .padding(.horizontal)
        .padding(.top, 20)
    }
    
    var factsView: some View {
        VStack(alignment: .leading) {
            Text("Facts")
                .bodyText2()
                .foregroundColor(.appTextWhite)
                .padding(.bottom, 8)
            
            ZStack(alignment: .topLeading) {
                Color.appSecondary
                Text("The IT Crowd is a British sitcom originally broadcast by Channel 4, written anThe IT Crowd is a British sitcom originally broadcast by Channel 4, written an")
                    .bodyText5()
                    .foregroundColor(.appTextWhite)
                    .padding(15)
            }.frame(maxHeight: 100)
            
            ZStack(alignment: .topLeading) {
                Color.appSecondary
                Text("The IT Crowd is a British sitcom originally broadcast by Channel 4, n")
                    .bodyText5()
                    .foregroundColor(.appTextWhite)
                    .padding(15)
            }.frame(maxHeight: 200)
            ZStack(alignment: .topLeading) {
                Color.appSecondary
                Text("The IT")
                    .bodyText5()
                    .foregroundColor(.appTextWhite)
                    .padding(15)
            }.frame(maxHeight: 100)
        }
        .padding(.horizontal)
        .padding(.top, 20)
    }
}

struct MovieScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MovieScreenView()
    }
}
