//
//  ContentView.swift
//  MovieTime
//
//  Created by Артём Грищенко on 11.05.2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var authViewModel = Injection.shared.container.resolve(AuthViewModel.self)!
    
    var body: some View {
        if authViewModel.isUserLoggedIn {
            NavigationView {
                MainScreenView()
            }.id(authViewModel.navigationViewUUID)
        } else {
            LoginScreenView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
