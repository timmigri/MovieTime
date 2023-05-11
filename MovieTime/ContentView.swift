//
//  ContentView.swift
//  MovieTime
//
//  Created by Артём Грищенко on 11.05.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color("appBackground").ignoresSafeArea()
            VStack {
                VStack {
                    Image("LoginIcon")
                        .padding(.bottom, 30)
                    Text("MovieTime Login")
                        .heading2()
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("appText"))
                        .padding(.bottom, 10)
                    Text("Please login to your account to know everything about movie world")
                        .bodyText5()
                        .foregroundColor(Color("appSecondary300"))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                }
                .frame(maxHeight: .infinity)
                Button(action: {}) {
                    Text("Login with")
                        .bodyText5()
                        .foregroundColor(.appText)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                }
                .frame(maxWidth: .infinity)
                .background(Color.appPrimary)
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
