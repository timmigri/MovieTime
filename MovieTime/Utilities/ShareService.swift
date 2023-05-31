//
//  ShareService.swift
//  MovieTime
//
//  Created by Артём Грищенко on 31.05.2023.
//

import Foundation
import UIKit

class ShareService: ShareServiceProtocol {
    static func shareMovie(_ movie: MovieModel, source: UIViewController) {
        var items = [Any]()
        if let url = URL(string: AppConstants.shareUrlMovie + String(movie.id)) {
            items.append(url)
        }
        var yearString = ""
        if let year = movie.year {
            yearString = " (\(year))"
        }
        let shareString = "Рекомендую: \(movie.name)\(yearString)"
        items.append(shareString)
        let viewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        viewController.popoverPresentationController?.sourceView = source.view
        source.present(viewController, animated: true)
    }}
