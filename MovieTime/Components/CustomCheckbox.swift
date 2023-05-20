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

    let size: CGFloat = 21

    var titleColor: Color {
        !isDisabled ? .appTextWhite : .appSecondary300
    }

    var fillColor: Color {
        !isDisabled ? .appPrimary : .appSecondary
    }

    var checkmarkSize: CGFloat {
        size * 0.5
    }

    var body: some View {
        HStack(spacing: 10) {
            if !checked {
                Circle()
                    .strokeBorder(.white)
                    .frame(width: size, height: size)
            } else {
                Circle()
                    .fill(fillColor)
                    .frame(width: size, height: size)
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.system(size: checkmarkSize))
                        //                        .clipShape(Rectangle().offset(x: animationOffset))
                            .foregroundColor(titleColor)
                    )
            }
            if let title {
                Text(title)
                    .bodyText4()
                    .foregroundColor(titleColor)
            }
        }
        .onTapGesture(perform: onCheck)
    }
}

struct CustomCheckbox_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            CustomCheckbox(checked: false, onCheck: { }, title: "Hi")
        }
    }
}
