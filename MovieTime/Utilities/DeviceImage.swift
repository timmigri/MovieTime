//
//  DeviceImage.swift
//  MovieTime
//
//  Created by Артём Грищенко on 01.06.2023.
//

import Foundation

struct DeviceImage {
    enum ImageType {
        case moviePoster(movieId: Int)
    }

    private static func getDeviceImageFromLocalURL(_ url: URL?) -> Data? {
        guard let imagePath = url else { return nil }
        if !FileManager.default.fileExists(atPath: imagePath.path) { return nil }
        guard let cert = NSData(contentsOfFile: imagePath.path) else { return nil }
        return cert as Data
    }

    private static func getFolderByImageType(_ type: ImageType) -> String {
        switch type {
        case .moviePoster:
            return "MovieTimePosters"
        }
    }

    private static func getFilenameByImageType(_ type: ImageType) -> String {
        switch type {
        case .moviePoster(let movieId):
            return String(movieId)
        }
    }

    private static func createDirectoryIfNotExist(_ path: String) -> Bool {
        if FileManager.default.fileExists(atPath: path) { return true }
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
            return true
        } catch {
            print("error creating directory \(path)")
        }
        return false
    }

    static func getImagePathOnDevice(_ type: ImageType) -> URL? {
        let imagesFolderUrl = try? FileManager.default.url(
            for: .picturesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        guard var imagesFolderUrl else { return nil }
        imagesFolderUrl = imagesFolderUrl.appendingPathComponent(getFolderByImageType(type))
        if createDirectoryIfNotExist(imagesFolderUrl.path) {
            return imagesFolderUrl
                .appendingPathComponent(getFilenameByImageType(type))
                .appendingPathExtension("png")
        }
        return nil
    }

    static func getImageFromLocalPath(_ type: ImageType) -> Data? {
        let url = getImagePathOnDevice(type)
        return getDeviceImageFromLocalURL(url)
    }
}
