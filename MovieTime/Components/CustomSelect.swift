//
//  CustomSelect.swift
//  MovieTime
//
//  Created by Артём Грищенко on 29.05.2023.
//

import Foundation
import SwiftUI

struct CustomSelect: View {
    struct SelectOption {
        let title: String
        let key: String
        var isSelected: Bool = false
    }

    let options: [SelectOption]
    let onSelectOption: (Int, String) -> Void

    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id: \.self) { index in
                renderOption(index)
            }
        }
    }

    private func renderOption(_ index: Int) -> some View {
        let option = options[index]

        let backgroundColor: Color = option.isSelected ? .appPrimary : .appPrimary200
        let textColor: Color = option.isSelected ? .appTextWhite : .appPrimary
        let leftCornerRadius: CGFloat = index == 0 ? 10 : 0
        let rightCornerRadius: CGFloat = index == options.count - 1 ? 10 : 0
        return Text(option.title)
            .bodyText5()
            .foregroundColor(textColor)
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(backgroundColor)
            .cornerRadius(leftCornerRadius, corners: .topLeft)
            .cornerRadius(leftCornerRadius, corners: .bottomLeft)
            .cornerRadius(rightCornerRadius, corners: .topRight)
            .cornerRadius(rightCornerRadius, corners: .bottomRight)
            .onTapGesture {
                onSelectOption(index, option.key)
            }
    }
}
