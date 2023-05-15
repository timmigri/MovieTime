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
            SearchScreenView()
                .tabItem {
                    HStack {
                        Image(selectedTabId != 1 ? Constants.searchIcon : Constants.searchActiveIcon)
                        Text(Constants.searchText)
                    }
                }
                .tag(1)
            MovieScreenView(
                id: 5213
            )
                .tabItem {
                    HStack {
                        Image(selectedTabId != 2 ? Constants.bookmarkIcon : Constants.bookmarkActiveIcon)
                        Text(Constants.bookmarkText)
                    }
                }
                .tag(2)
        }
        .accentColor(.appPrimary)
    }

    private struct Constants {
        static let searchText = "Search"
        static let bookmarkText = "Bookmarks"
        static let searchIcon = "SearchIcon"
        static let searchActiveIcon = "SearchActiveIcon"
        static let bookmarkIcon = "BookmarkIcon"
        static let bookmarkActiveIcon = "BookmarkActiveIcon"
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}
