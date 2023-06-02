//
//  GenreSelector.swift
//  MovieTime
//
//  Created by Артём Грищенко on 02.06.2023.
//

import Foundation
import SwiftUI

struct GenreSelector: View {
    let genres: [GenreModel]
    let onChange: ([Int]) -> Void
    let selectedGenresIndexes: [Int]
    @State var genresVisibility: [Bool]

    init(
        genres: [GenreModel],
        selectedGenresIndexes: [Int],
        onChange: @escaping ([Int]) -> Void) {
        self.genres = genres
        self.onChange = onChange
        self.selectedGenresIndexes = selectedGenresIndexes
        self.genresVisibility = Array(repeating: false, count: genres.count)
    }

    func onAppear() {
        let totalDuration: CGFloat = 0.5
        for index in genresVisibility.indices {
            let after: CGFloat = totalDuration * CGFloat(index + 1) / CGFloat(genresVisibility.count)
            DispatchQueue.main.asyncAfter(deadline: .now() + after) {
                withAnimation {
                    self.genresVisibility[index] = true
                }
            }
        }
    }

    func onChooseGenre(_ index: Int) {
        if !canSelectGenre(index) { return }
        withAnimation(.easeInOut(duration: 0.2)) {
            if selectedGenresIndexes.contains(index) {
                onChange(selectedGenresIndexes.filter { $0 != index })
            } else if selectedGenresIndexes.count < AppConstants.maxFilterCategories {
                onChange(selectedGenresIndexes + [index])
            }
        }
    }

    func resetFilterCategories() {
        withAnimation(.easeInOut(duration: 0.2)) {
            onChange([])
        }
    }

    func canSelectGenre(_ index: Int) -> Bool {
        return selectedGenresIndexes.contains(index) || selectedGenresIndexes.count < AppConstants.maxFilterCategories
    }

    var body: some View {
        VStack {
            genresTitle
            genresGridView
        }
    }

    var genresTitle: some View {
        HStack {
            Text(R.string.filter.chooseGenresTitle())
                .bodyText2()
                .foregroundColor(.appTextWhite)
            Spacer()
            if selectedGenresIndexes.count > 0 {
                Button(R.string.filter.clearButtonText()) {
                    resetFilterCategories()
                }
                .foregroundColor(.appPrimary)
            }
        }
        .padding(.bottom, 20)
        .onAppear {
            onAppear()
        }
    }

    var genresGridView: some View {
        LazyVGrid(
            columns: [GridItem(.flexible()), GridItem(.flexible())],
            spacing: 20
        ) {
            ForEach(genres.indices, id: \.self) { index in
                let category = genres[index]
                CustomCheckbox(
                    checked: selectedGenresIndexes.contains(index),
                    onCheck: { onChooseGenre(index) },
                    title: category.name.capitalized,
                    isDisabled: !canSelectGenre(index)
                )
                .padding(.horizontal, 10)
                .padding(.vertical, 23)
                .frame(maxWidth: .infinity, alignment: .leading)
                .conditionTransform(category.pictureName != nil) { view in
                    view.background(
                        Image(category.pictureName!)
                            .resizable()
                            .cornerRadius(8)
                    )
                }
                .onTapGesture {
                    onChooseGenre(index)
                }
                .opacity(genresVisibility[index] ? 1 : 0)
            }
        }
    }
}

struct GenreSelector_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            GenreSelector(
                genres: GenreModel.generateBasicGenres(),
                selectedGenresIndexes: [1],
                onChange: { _ in }
            )
        }
    }
}
