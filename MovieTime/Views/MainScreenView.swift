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
                        Image(selectedTabId != 1 ? "Icons/Search" : "Icons/SearchActive")
                        Text("Поиск")
                    }
                }
                .tag(1)
            BookmarkScreenView()
                .tabItem {
                    HStack {
                        Image(selectedTabId != 2 ? "Icons/Bookmark" : "Icons/BookmarkActive")
                        Text("Избранное")
                    }
                }
                .tag(2)
            ProfileScreenView()
                .tabItem {
                    HStack {
                        Image(selectedTabId != 3 ? "Icons/Profile" : "Icons/ProfileActive")
                        Text("Профиль")
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
