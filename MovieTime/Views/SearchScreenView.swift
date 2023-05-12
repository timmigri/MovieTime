//
//  SearchScreenView.swift
//  MovieTime
//
//  Created by Артём Грищенко on 12.05.2023.
//

import SwiftUI

struct SearchScreenView: View {
    @State private var query: String = ""
    @State private var searchFieldFocused = false

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            VStack {
                HStack(spacing: 7) {
                    Image("SearchIcon")
                        .padding(.leading, 10)
                        .padding(.vertical, 10)
                        .animation(.easeInOut, value: 5)
                    TextField("Search for Movies, Series", text: $query) {
                        searchFieldFocused = $0
                    }
                    .frame(height: 44)
                    .accentColor(.appPrimary)
                    .foregroundColor(.appSecondary300)
                    Image("FilterIcon")
                        .padding(.leading, 10)
                        .padding(.vertical, 10)
                        .animation(.easeInOut, value: 5)
                        .padding(.trailing, 10)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                    .stroke(
                        searchFieldFocused ? Color.appPrimary : Color.appSecondary300, lineWidth: 1
                    )
                )
                GeometryReader { geometry in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            actorsSection(geometry)
                            moviesSection(geometry)
                        }
                    }
                }
                .padding(.top, 32)
                .frame(maxHeight: .infinity)
//                PictureBox(
//                    pictureName: "SearchPicture",
//                    headlineText: "Search in MovieTime",
//                    bodyText: "By typing in search box, MovieTime search in movies, series and actors then show you the best results."
//                )

//                PictureBox(
//                    pictureName: "NoResultPicture",
//                    headlineText: "No result",
//                    bodyText: "No results found, Please try other words"
//                )
            }
            .padding()
        }
    }

    func actorsSection(_ geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading) {
            Text("Actors")
                .bodyText4()
                .foregroundColor(.appTextWhite)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    testActor(geometry)
                    testActor(geometry)
                    testActor(geometry)
                    testActor(geometry)
                    testActor(geometry)
                    testActor(geometry)
                }

            }
        }
    }

    func moviesSection(_ geometry: GeometryProxy) -> some View {
        return VStack(alignment: .leading) {
            Text("Movies & Series")
                .bodyText4()
                .foregroundColor(.appTextWhite)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                testMovie(geometry)
                testMovie(geometry)
                testMovie(geometry)
            }
        }
    }

    func testActor(_ geometry: GeometryProxy) -> some View {
        let padding: CGFloat = 10
        let width = (geometry.size.width - padding * 4) / 4
        return VStack {
            Image("ActorExample")
                .frame(width: width, height: width)
            Text("Dwayne Johnson")
                .caption2()
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(2)
                .foregroundColor(.appSecondary300)
                .multilineTextAlignment(.center)
                .padding(.bottom, 30)
        }
        .frame(maxWidth: width)
    }

    func testMovie(_ geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image("MovieExample")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: geometry.size.width / 2 - 10)
            Text("Black Lightning")
                .bodyText3()
                .foregroundColor(.appTextWhite)
            HStack {
                Text("4 seasons")
                    .caption2()
                    .foregroundColor(.appTextBlack)
                Spacer()
                HStack(spacing: 2) {
                    Image("StarIcon")
                    Text("4.1")
                        .bodyText5()
                        .foregroundColor(.appTextWhite)
                }
            }
        }
    }
}

struct SearchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreenView()
    }
}
