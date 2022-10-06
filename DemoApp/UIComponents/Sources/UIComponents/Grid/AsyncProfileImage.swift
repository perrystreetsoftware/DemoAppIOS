//
//  File.swift
//  
//
//  Created by Eric Silverberg on 10/5/22.
//

import Foundation
import SwiftUI
import UIKit
import SDWebImage
import Combine

public enum ImageLoaderState {
    case empty
    case success(image: Image)
    case failure(error: Error)
}

private class ImageLoader: ObservableObject {
    @Published var state: ImageLoaderState = .empty

    private var request: URLRequest?
    private var cancellable: AnyCancellable?

    func load(request: URLRequest?,
              options: [PSSImageRepositoryImageOptions]?) {
        assert(Thread.isMainThread, "This must be called only on the main thread")
        assert(cancellable == nil, "Why are we loading twice")

        guard let request = request else {
            state = .empty
            return
        }

        if let image = SDWebImageManager.shared.loadImageFromCache(urlRequest: request, options: options) {
            state = .success(image: Image(uiImage: image))
            return
        }

        let loadImagePublisher: AnyPublisher<PSSImageRepositoryImage, RemoteImageFacadeError> =
        SDWebImageManager.shared.loadImage(urlRequest: request, options: options)
            .compactMap { event -> PSSImageRepositoryImage? in
                switch event {
                case .completed(let image):
                    return image
                default:
                    return nil
                }
            }.eraseToAnyPublisher()

        cancellable?.cancel()
        cancellable = loadImagePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.state = .failure(error: error)
                default:
                    break
                }
            }, receiveValue: { [weak self] (image) in
                print("*** Image loading for: \(request.url)")
                self?.state = .success(image: Image(uiImage: image))
            })
    }

    func cancel() {
        cancellable?.cancel()
    }
}

public struct AsyncProfileImage: View {
    @StateObject private var loader = ImageLoader()

    private let request: URLRequest?
    private let placeholder: PSSImageRepositoryImage?

    public init(request: URLRequest?,
                placeholder: UIImage? = nil) {
        self.request = request
        self.placeholder = placeholder
    }

    @MainActor
    public var body: some View {
        Group {
            switch loader.state {
            case .empty:
                let _ = loader.load(request: request,
                                    options: nil)

                Image(uiImage: placeholder ?? UIImage())
                    .resizable()
                    .renderingMode(.original)
            case .success(let image):
                image.resizable().renderingMode(.original)
            case .failure:
                Image(uiImage: placeholder ?? UIImage())
                    .resizable()
                    .renderingMode(.original)
            }
        }
        .aspectRatio(contentMode: .fill)
    }
}
