//
//  LoadingIndicator.swift
//  MovieTime
//
//  Created by Артём Грищенко on 15.05.2023.
//

import SwiftUI

struct LoadingIndicator: View {
    var condition: Bool?

    var showIndicator: Bool {
        guard let condition else { return true }
        return condition
    }

    var body: some View {
        if showIndicator {
            ProgressView()
                .progressViewStyle(
                    CircularProgressViewStyle(tint: .appPrimary200))
        }
    }
}

struct LoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicator()
    }
}
