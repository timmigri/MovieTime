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
                        Image(selectedTabId != 1 ? R.image.icons.search.name : R.image.icons.searchActive.name)
                        Text(R.string.tabBar.search())
                    }
                }
                .tag(1)
            BookmarkScreenView()
                .tabItem {
                    HStack {
                        Image(selectedTabId != 2 ? R.image.icons.bookmark.name : R.image.icons.bookmarkActive.name)
                        Text(R.string.tabBar.favorite())
                    }
                }
                .tag(2)
            ProfileScreenView()
                .tabItem {
                    HStack {
                        Image(selectedTabId != 3 ? R.image.icons.profile.name : R.image.icons.profileActive.name)
                        Text(R.string.tabBar.profile())
                    }
                }
                .tag(3)
        }
        .accentColor(.appPrimary)
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}
