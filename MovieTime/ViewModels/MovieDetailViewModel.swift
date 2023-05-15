//
//  MovieDetailViewModel.swift
//  MovieTime
//
//  Created by Артём Грищенко on 15.05.2023.
//

import Foundation
import SwiftUI

class MovieDetailViewModel: ObservableObject {
    let id: Int
    @Published var isLoadingMovie: Bool
    @Published var movie: MovieDetailModel?
    @Published var scrollViewOffset: CGFloat = 0.0
    @Injected var networkManager: NetworkManager
    
    func showAdvancedTopBar(_ screenHeight: CGFloat) -> Bool {
        return movie != nil && scrollViewOffset < screenHeight * 0.6
    }

    init(id: Int) {
        self.id = id
        self.isLoadingMovie = false
    }

    func loadMovie() {
        print("Load movie: \(id)")
        isLoadingMovie = true
        networkManager.loadMovie(id: id) { res in
            DispatchQueue.main.async {
                print(res)
                self.movie = res
                self.isLoadingMovie = false
            }
        }
    }
    
    func onUpdateScrollPosition(_ value: CGFloat) {
        scrollViewOffset = value
    }
}
