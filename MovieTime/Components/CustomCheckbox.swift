//
//  CustomCheckbox.swift
//  MovieTime
//
//  Created by Артём Грищенко on 12.05.2023.
//

import SwiftUI

struct CustomCheckbox: View {
    let checked: Bool
    let onCheck: () -> Void
    var title: String?
    var isDisabled: Bool = false

    var titleColor: Color {
        !isDisabled ? .appTextWhite : .appSecondary300
    }

    var body: some View {
        HStack(spacing: 10) {
            Image(checked ? "Icons/CheckboxActive" : "Icons/Checkbox")
                .onTapGesture(perform: onCheck)
            if let title {
                Text(title)
                    .bodyText4()
                    .foregroundColor(titleColor)
            }
        }
    }
}

struct CustomCheckbox_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            CustomCheckbox(checked: true, onCheck: { }, title: "Hi", isDisabled: true)
        }
    }
}
