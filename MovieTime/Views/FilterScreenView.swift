//
//  FilterScreenView.swift
//  MovieTime
//
//  Created by Артём Грищенко on 12.05.2023.
//

import SwiftUI

struct FilterScreenView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel = Injection.shared.container.resolve(SearchViewModel.self)!

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.appBackground.ignoresSafeArea()
            VStack {
                CustomNavigationBar(
                    onTapGesture: {
                        viewModel.onChangeSearchOptions()
                    },
                    title: "Фильтры"
                )
                ScrollView(.vertical, showsIndicators: false) {
                    sortKeyRowView
                    filterTextRowView
                    filterCategoriesListView
                }
                Spacer()
            }
            .padding()
            .onAppear {
                viewModel.onAppearFilterScreenView()
            }

            CustomButton(
                action: {
                    viewModel.onChangeSearchOptions()
                    self.presentationMode.wrappedValue.dismiss()
                },
                title: "Показать результаты"
            )
            .scaleEffect(viewModel.isSomeFilterActive ? 1 : 0.001, anchor: .center)
            .padding()
        }
        .navigationBarHidden(true)
    }

    var sortKeyRowView: some View {
        VStack(alignment: .leading) {
            Text("Сортировать по")
                .bodyText2()
                .foregroundColor(.appTextWhite)
            HStack(spacing: 0) {
                ForEach(viewModel.sortOptions.indices, id: \.self) { index in
                    renderSortOption(index)
                }
                Spacer()
            }
        }
        .padding(.bottom, 20)
    }

    func renderSortOption(_ index: Int) -> some View {
        let isActive = viewModel.isSortOptionActive(index)
        let backgroundColor: Color = isActive ? .appPrimary : .appPrimary200
        let textColor: Color = isActive ? .appTextWhite : .appPrimary
        let leftCornerRadius: CGFloat = index == 0 ? 10 : 0
        let rightCornerRadius: CGFloat = index == viewModel.sortOptions.count - 1 ? 10 : 0
        return backgroundColor.overlay(
            Text(viewModel.sortOptions[index].0)
                .bodyText5()
                .foregroundColor(textColor)
        )
        .frame(width: 90, height: 36)
        .cornerRadius(leftCornerRadius, corners: .topLeft)
        .cornerRadius(leftCornerRadius, corners: .bottomLeft)
        .cornerRadius(rightCornerRadius, corners: .topRight)
        .cornerRadius(rightCornerRadius, corners: .bottomRight)
        .onTapGesture {
            viewModel.onSelectSortOption(index)
        }
    }

    var filterTextRowView: some View {
        HStack {
            Text("Выберите жанры")
                .bodyText2()
                .foregroundColor(.appTextWhite)
            Spacer()
            if viewModel.countSelectedFilterCategories > 0 {
                Button("Очистить") { viewModel.resetFilterCategories() }
                    .foregroundColor(.appPrimary)
            }
        }
        .padding(.bottom, 20)
    }

    var filterCategoriesListView: some View {
        LazyVGrid(
            columns: [GridItem(.flexible()), GridItem(.flexible())],
            spacing: 20
        ) {
            ForEach(viewModel.filterCategories.indices, id: \.self) { index in
                let category = viewModel.filterCategories[index]
                HStack(spacing: 10) {
                    CustomCheckbox(
                        checked: category.isSelected,
                        onCheck: { viewModel.onChooseFilterCategory(category.id)
                        },
                        title: category.name,
                        isDisabled: !viewModel.canSelectFilterCategory(category)
                    )
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 23)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    Image(category.pathToPicture)
                        .resizable()
                        .cornerRadius(8)
                )
                .onTapGesture {
                    viewModel.onChooseFilterCategory(category.id)
                }
                .opacity(viewModel.filterCategoriesVisibility[index] ? 1 : 0)
            }
        }
    }
}

struct FilterScreenView_Previews: PreviewProvider {
    static var previews: some View {
        FilterScreenView()
    }
}
