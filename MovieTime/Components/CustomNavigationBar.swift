//
//  CustomNavigationBar.swift
//  MovieTime
//
//  Created by Артём Грищенко on 16.05.2023.
//

import SwiftUI

struct CustomNavigationBar: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let onTapGesture: () -> Void
    let title: String?

    var body: some View {
        ZStack(alignment: .leading) {
            Image("ArrowBackIcon")
                .onTapGesture {
                    onTapGesture()
                    self.presentationMode.wrappedValue.dismiss()

                }
            if let title {
                Text(title)
                    .bodyText()
                    .foregroundColor(.appTextWhite)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 30)
            }
        }
        .frame(maxHeight: 30)
        .padding(.bottom, 20)
    }
}

struct CustomNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavigationBar(onTapGesture: { }, title: "Navigation bar")
    }
}
