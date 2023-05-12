//
//  FilterScreenView.swift
//  MovieTime
//
//  Created by Артём Грищенко on 12.05.2023.
//

import SwiftUI

struct FilterScreenView: View {
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            VStack {
                topRow
                ScrollView(.vertical, showsIndicators: false) {
                    sortKeyRow
                    filterTextRow
                    genres
                }
                Spacer()
            }
            .padding()
        }
    }

    var topRow: some View {
        HStack(alignment: .top) {
            Image("ArrowBackIcon")
            Spacer()
        }
        .frame(height: 44)
        .padding(.bottom, 20)
    }
    
    var sortKeyRow: some View {
        VStack(alignment: .leading) {
            Text("Sort by")
                .bodyText2()
                .foregroundColor(.appTextWhite)
            HStack(spacing: 0) {
                Color.appPrimary.overlay(
                    Text("Title")
                        .bodyText5()
                        .foregroundColor(.appTextWhite)
                )
                .frame(width: 90, height: 36)
                .cornerRadius(10, corners: .topLeft)
                .cornerRadius(10, corners: .bottomLeft)
                Color.appPrimary200.overlay(
                    Text("Date")
                        .bodyText5()
                        .foregroundColor(.appPrimary)
                ).frame(width: 90, height: 36)
                Color.appPrimary200.overlay(
                    Text("Rating")
                        .bodyText5()
                        .foregroundColor(.appPrimary)
                )
                .frame(width: 90, height: 36)
                .cornerRadius(10, corners: .topRight)
                .cornerRadius(10, corners: .bottomRight)
                Spacer()
            }
        }
        .padding(.bottom, 20)
    }

    var filterTextRow: some View {
        HStack {
            Text("Choose genre")
                .bodyText2()
                .foregroundColor(.appTextWhite)
            Spacer()
            Button("Reset") {
                
            }.foregroundColor(.appPrimary)
        }
        .padding(.bottom, 20)
    }

    var genres: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
            ForEach(FilterCategory.getCategories()) { category in
                Image(category.pictureName)
                    .cornerRadius(8)
                    .overlay(
                    Text(category.name)
                        .bodyText4()
                        .foregroundColor(.appTextWhite)
                )
            }
        }
    }
}

struct FilterScreenView_Previews: PreviewProvider {
    static var previews: some View {
        FilterScreenView()
    }
}
