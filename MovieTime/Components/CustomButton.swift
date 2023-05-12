//
//  Button.swift
//  MovieTime
//
//  Created by Артём Грищенко on 12.05.2023.
//

import SwiftUI

struct CustomButton: View {
    let action: () -> Void
    let title: String
    var body: some View {
        Button(action: action) {
            Text(title)
                .bodyText5()
                .foregroundColor(.appTextWhite)
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity)
        .background(Color.appPrimary)
        .cornerRadius(10)
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(action: { }, title: "Button title")
    }
}
