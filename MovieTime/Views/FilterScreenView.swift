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
            HStack {
                Text("Сортировать по")
                    .bodyText2()
                    .foregroundColor(.appTextWhite)
                Spacer()
            }
            CustomSelect(
                options: viewModel.sortOptions,
                onSelectOption: viewModel.onSelectSortOption
            )
        }
        .padding(.bottom, 20)
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
