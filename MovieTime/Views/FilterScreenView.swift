//
//  FilterScreenView.swift
//  MovieTime
//
//  Created by Артём Грищенко on 12.05.2023.
//

import SwiftUI

struct FilterScreenView: View {
    @ObservedObject var searchViewModel = SearchViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
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
            if searchViewModel.showFilterResultsButton {
                CustomButton(action: { }, title: "Show Results")
                    .padding()
            }
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
                ForEach(searchViewModel.sortOptions.indices, id: \.self) { index in
                    renderSortOption(index)
                }
                Spacer()
            }
        }
        .padding(.bottom, 20)
    }

    func renderSortOption(_ index: Int) -> some View {
        let isActive = searchViewModel.isSortOptionActive(index)
        let backgroundColor: Color = isActive ? .appPrimary : .appPrimary200
        let textColor: Color = isActive ? .appTextWhite : .appPrimary
        let leftCornerRadius: CGFloat = index == 0 ? 10 : 0
        let rightCornerRadius: CGFloat = index == searchViewModel.sortOptions.count - 1 ? 10 : 0
        return backgroundColor.overlay(
            Text(searchViewModel.sortOptions[index].0)
                .bodyText5()
                .foregroundColor(textColor)
        )
        .frame(width: 90, height: 36)
        .cornerRadius(leftCornerRadius, corners: .topLeft)
        .cornerRadius(leftCornerRadius, corners: .bottomLeft)
        .cornerRadius(rightCornerRadius, corners: .topRight)
        .cornerRadius(rightCornerRadius, corners: .bottomRight)
        .onTapGesture {
            searchViewModel.onChooseSortOption(index)
        }
    }

    var filterTextRow: some View {
        HStack {
            Text("Choose genre")
                .bodyText2()
                .foregroundColor(.appTextWhite)
            Spacer()
            if (searchViewModel.countChoosedFilterCategories > 0) {
                Button("Reset") { searchViewModel.resetFilterCategories() }
                    .foregroundColor(.appPrimary)
            }
        }
        .padding(.bottom, 20)
    }

    var genres: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
            ForEach(searchViewModel.filterCategories) { category in
                Image(category.pictureName)
                    .cornerRadius(8)
                    .scaleEffect(1.1)
                    .onTapGesture {
                        searchViewModel.onChooseFilterCategory(category.id)
                    }
                    .overlay(
                        HStack(spacing: 10) {
                            CustomCheckbox(checked: category.isChoosed, onCheck: { })
                            Text(category.name)
                                .bodyText4()
                                .foregroundColor(searchViewModel.canChooseFilterCategory(category.isChoosed) ? .appTextWhite : .appSecondary300)
                            Spacer()
                        }
                        .padding(.leading, 10)
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
