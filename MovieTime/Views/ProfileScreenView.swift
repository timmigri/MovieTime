//
//  ProfileScreenView.swift
//  MovieTime
//
//  Created by Артём Грищенко on 23.05.2023.
//

import Foundation
import SwiftUI

struct ProfileScreenView: View {
    @ObservedObject var authViewModel = Injection.shared.container.resolve(AuthViewModel.self)!

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            Button(R.string.profile.logout()) {
                authViewModel.logout()
            }
        }
    }
}
