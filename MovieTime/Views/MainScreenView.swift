//
//  MainScreenView.swift
//  MovieTime
//
//  Created by Артём Грищенко on 11.05.2023.
//

import SwiftUI

struct MainScreenView: View {
    @State private var selectedTabId = 1

    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color.appSecondary)
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = UIColor(Color.appSecondary300)
    }

    var body: some View {
        TabView(selection: $selectedTabId) {
            FilterScreenView()
                .tabItem {
                    HStack {
                        Image(selectedTabId != 1 ? Constants.searchIcon : Constants.searchActiveIcon)
                        Text(Constants.searchText)
                    }
                }
                .tag(1)
            FavoriteScreenView()
                .tabItem {
                    HStack {
                        Image(selectedTabId != 2 ? Constants.favoriteIcon : Constants.favoriteActiveIcon)
                        Text(Constants.searchText)
                    }
                }
                .tag(2)
        }
        .accentColor(.appPrimary)
    }

    private struct Constants {
        static let searchText = "Search"
        static let favoriteText = "Favorite"
        static let searchIcon = "SearchIcon"
        static let searchActiveIcon = "SearchActiveIcon"
        static let favoriteIcon = "FavoriteIcon"
        static let favoriteActiveIcon = "FavoriteActiveIcon"
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}
