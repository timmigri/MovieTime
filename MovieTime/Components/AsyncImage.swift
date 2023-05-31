// Source: https://github.com/V8tr/AsyncImage

 import Foundation
 import SwiftUI
 import UIKit
 import Combine

 struct AsyncImage<Placeholder: View>: View {
     @StateObject private var loader: ImageLoader
     private let placeholder: Placeholder
     private let image: (UIImage) -> Image

     init(
         url: URL,
         @ViewBuilder placeholder: () -> Placeholder,
         @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:),
         onFinishLoading: @escaping (UIImage?) -> Void = { _ in }
     ) {
         self.placeholder = placeholder()
         self.image = image
         _loader = StateObject(wrappedValue: ImageLoader(
            url: url,
            cache: Environment(\.imageCache).wrappedValue,
            onFinishLoading: onFinishLoading
         ))
     }

     var body: some View {
         content
             .onAppear(perform: loader.load)
     }

     private var content: some View {
         Group {
             if let loaderImage = loader.image {
                 image(loaderImage)
             } else {
                 placeholder
             }
         }
     }
 }

 protocol ImageCache {
     subscript(_ url: URL) -> UIImage? { get set }
 }

 struct TemporaryImageCache: ImageCache {
     private let cache = NSCache<NSURL, UIImage>()

     subscript(_ key: URL) -> UIImage? {
         get { cache.object(forKey: key as NSURL) }
         set {
             if let newValue {
                 cache.setObject(newValue, forKey: key as NSURL)
             } else {
                 cache.removeObject(forKey: key as NSURL)
             }
         }
     }
 }

 class ImageLoader: ObservableObject {
     @Published var image: UIImage?

     private(set) var isLoading = false

     private let url: URL
     private var cache: ImageCache?
     private var cancellable: AnyCancellable?
     private var onFinishLoading: (UIImage?) -> Void

     private static let imageProcessingQueue = DispatchQueue(label: "image-processing")

     init(url: URL, cache: ImageCache? = nil, onFinishLoading: @escaping (UIImage?) -> Void) {
         self.url = url
         self.cache = cache
         self.onFinishLoading = onFinishLoading
     }

     deinit {
         cancel()
     }

     func load() {
         guard !isLoading else { return }

         if let image = cache?[url] {
             self.image = image
             self.onFinishLoading(image)
             return
         }

         cancellable = URLSession.shared.dataTaskPublisher(for: url)
             .map { UIImage(data: $0.data) }
             .replaceError(with: nil)
             .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                           receiveOutput: { [weak self] in self?.cache($0) },
                           receiveCompletion: { [weak self] _ in self?.onFinish() },
                           receiveCancel: { [weak self] in self?.onFinish() })
             .subscribe(on: Self.imageProcessingQueue)
             .receive(on: DispatchQueue.main)
             .sink { [weak self] in
                 self?.image = $0
                 self?.onFinishLoading($0)
             }
     }

     func cancel() {
         cancellable?.cancel()
     }

     private func onStart() {
         isLoading = true
     }

     private func onFinish() {
         isLoading = false
     }

     private func cache(_ image: UIImage?) {
         image.map { cache?[url] = $0 }
     }
 }

 struct ImageCacheKey: EnvironmentKey {
     static let defaultValue: ImageCache = TemporaryImageCache()
 }

 extension EnvironmentValues {
     var imageCache: ImageCache {
         get { self[ImageCacheKey.self] }
         set { self[ImageCacheKey.self] = newValue }
     }
 }
