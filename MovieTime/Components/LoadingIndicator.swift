//
//  LoadingIndicator.swift
//  MovieTime
//
//  Created by Артём Грищенко on 15.05.2023.
//

import SwiftUI

struct LoadingIndicator: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(
                CircularProgressViewStyle(tint: .appPrimary200))
    }
}

struct LoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicator()
    }
}
