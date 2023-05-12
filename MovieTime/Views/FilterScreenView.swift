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
                filterTextRow
                genres
            }
            .padding()
        }
    }

    var topRow: some View {
        HStack {
            Image("ArrowBackIcon")
            Spacer()
        }
        .frame(height: 44)
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
                Image("ActionBackground").overlay(
                    Text("Action")
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
