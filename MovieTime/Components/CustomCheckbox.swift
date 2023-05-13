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

    var body: some View {
        Image(checked ? "CheckboxCheckedIcon" : "CheckboxUncheckedIcon")
            .onTapGesture(perform: onCheck)
    }
}

struct CustomCheckbox_Previews: PreviewProvider {
    static var previews: some View {
        CustomCheckbox(checked: true, onCheck: { })
    }
}
