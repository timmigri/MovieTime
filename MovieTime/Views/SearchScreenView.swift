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
                .overlay(RoundedRectangle(cornerRadius: 5)
                    .stroke(searchFieldFocused ? Color.appPrimary : Color.appSecondary300, lineWidth: 1))
                ScrollView {
                    actorsSection
                }
                .padding(.top, 32)
                .frame(maxHeight: .infinity)
            }
            .padding()
        }
    }
    
    var actorsSection: some View {
        VStack(alignment: .leading) {
            Text("Actors")
                .bodyText3()
                .foregroundColor(.appTextWhite)
            GeometryReader { geometry in
                HStack(alignment: .top, spacing: 0) {
                    testActor(geometry)
                    testActor(geometry)
                    testActor(geometry)
                    testActor(geometry)
                    testActor(geometry)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func testActor(_ geometry: GeometryProxy) -> some View {
        let padding: CGFloat = 10
        let width = (geometry.size.width - padding * 4) / 4
        print(width, geometry.size.width)
        return VStack {
            Image("ActorExample")
                .frame(width: width, height: width)
            Text("Dwayne Johnson")
                .caption2()
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(2)
                .foregroundColor(.appSecondary300)
                .multilineTextAlignment(.center)
        }
    }

    var noInputView: some View {
        VStack {
            Image("SearchPicture")
                .padding(.bottom, 30)
            Text("Search in MovieTime")
                .heading2()
                .multilineTextAlignment(.center)
                .foregroundColor(.appTextWhite)
                .padding(.bottom, 10)
            Text("By typing in search box, MovieTime search in movies, series and actors then show you the best results.")
                .bodyText5()
                .multilineTextAlignment(.center)
                .foregroundColor(.appTextBlack)
                .padding(.bottom, 10)
        }
        .frame(maxHeight: .infinity)
    }
    
    var noResultView: some View {
        VStack {
            Image("NoResultPicture")
                .padding(.bottom, 25)
            Text("No result")
                .heading2()
                .multilineTextAlignment(.center)
                .foregroundColor(.appTextWhite)
                .padding(.bottom, 10)
            Text("No results found, Please try other words")
                .bodyText5()
                .multilineTextAlignment(.center)
                .foregroundColor(.appTextBlack)
                .padding(.bottom, 10)
        }
        .frame(maxHeight: .infinity)
    }

}

struct SearchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreenView()
    }
}
