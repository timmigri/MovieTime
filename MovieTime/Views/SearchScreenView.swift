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
                        .padding(.trailing, 10)
                }
                .overlay(RoundedRectangle(cornerRadius: 5)
                    .stroke(searchFieldFocused ? Color.appPrimary : Color.appSecondary300, lineWidth: 1))
//                ScrollView {
//
//                }.frame(maxHeight: .infinity)
                noInputView
            }
            .padding()
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

}

struct SearchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreenView()
    }
}
