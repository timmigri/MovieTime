//
//  MovieTimeApp.swift
//  MovieTime
//
//  Created by Артём Грищенко on 11.05.2023.
//

import SwiftUI
import GoogleSignIn

@main
struct MovieTimeApp: App {
    @ObservedObject var authViewModel = Injection.shared.container.resolve(AuthViewModel.self)!
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
                .onAppear {
                    authViewModel.restoreAuth()
                }
        }
    }
}
