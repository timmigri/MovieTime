//
//  FilterScreenView.swift
//  MovieTime
//
//  Created by Артём Грищенко on 12.05.2023.
//

import SwiftUI

struct FilterScreenView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel = AuthInjection.shared.container.resolve(SearchViewModel.self)!

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.appBackground.ignoresSafeArea()
            VStack {
                CustomNavigationBar(
                    onTapGesture: {
                        viewModel.onChangeSearchOptions()
                    },
                    title: R.string.filter.navbarTitle()
                )
                ScrollView(.vertical, showsIndicators: false) {
                    sortKeyRowView
                    GenreSelector(
                        genres: viewModel.genres,
                        selectedGenresIndexes: viewModel.selectedGenresIndexes,
                        onChange: viewModel.onChangeSelectedGenres
                    )
                }
                Spacer()
            }
            .padding()

            CustomButton(
                action: {
                    viewModel.onChangeSearchOptions()
                    self.presentationMode.wrappedValue.dismiss()
                },
                title: R.string.filter.showResultsButtonText()
            )
            .scaleEffect(viewModel.isSomeFilterActive ? 1 : 0.001, anchor: .center)
            .padding()
        }
        .navigationBarHidden(true)
    }

    var sortKeyRowView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(R.string.filter.sortBy())
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
}

struct FilterScreenView_Previews: PreviewProvider {
    static var previews: some View {
        FilterScreenView()
    }
}
