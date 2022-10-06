//
//  File.swift
//  
//
//  Created by Eric Silverberg on 10/5/22.
//

import Foundation
import SDWebImage
import Combine
import UIKit

extension SDWebImageOptions {
    init(options: [PSSImageRepositoryImageOptions]) {

        let rawOptions = options.compactMap { (option) -> SDWebImageOptions? in
            switch option {
            case .retryFailed:
                return SDWebImageOptions.retryFailed
            case.lowPriority:
                return SDWebImageOptions.lowPriority
            case .highPriority:
                return SDWebImageOptions.highPriority
            case .continueInBackground:
                return SDWebImageOptions.continueInBackground
            case .cachedWith:
                return nil
            case .cachedWithURL:
                return nil
            case .blurRadius:
                return nil
            case .loadingInto:
                return nil
            }
        }

        self = SDWebImageOptions(rawOptions)
    }
}

// so we can build on a mac, mostly to run the tests faster
#if !os(macOS)
import UIKit
public typealias PSSImageRepositoryImage = UIImage
public typealias PSSLoadingInfoImageView = UIImageView
#else
import AppKit
public typealias PSSImageRepositoryImage = NSImage
public typealias PSSLoadingInfoImageView = AnyObject
#endif

public enum RemoteImageFacadeError: Error {
    case sdWebImageError(error: Error?)
    case unknownError
    case noCacheKey
    case missingFile
    case dataNotCached
    case missingUrl
}

public enum PSSImageDownloadEvent {
    case progress(percent: Float)
    // This includes both the image and data; this is because
    // Animated GIFs require us to use the Data class; normally it is
    // fine to just use the PSSImageRepositoryImage type
    case completed(image: UIImage)
}

public enum PSSImageRepositoryImageOptions {
    case retryFailed
    case lowPriority
    case highPriority
    case continueInBackground
    case cachedWith(cacheKey: String)
    case cachedWithURL(url: URL)
    case blurRadius(radius: Float)
    case loadingInto(imageView: PSSLoadingInfoImageView, placeholder: PSSImageRepositoryImage?)
}

extension Array where Element == PSSImageRepositoryImageOptions {
    public var blurRadius: Float? {
        return self.compactMap({ (option) -> Float? in
            if case .blurRadius(let radius) = option {
                return radius
            } else {
                return nil
            }
        }).first
    }

    public var targetImageView: UIImageView? {
        return self.compactMap({ (option) -> UIImageView? in
            if case .loadingInto(let imageView, _) = option {
                return imageView
            } else {
                return nil
            }
        }).first
    }

    public var placeholder: PSSImageRepositoryImage? {
        return self.compactMap({ (option) -> PSSImageRepositoryImage? in
            if case .loadingInto(_, let placeholder) = option {
                return placeholder
            } else {
                return nil
            }
        }).first
    }

    public var cacheKeyContext: [SDWebImageContextOption: Any] {
        var context: [SDWebImageContextOption: Any] = [:]

        if let blurRadius = self.blurRadius, blurRadius > 0 {
            context[SDWebImageContextOption.imageTransformer] = SDImageBlurTransformer(radius: CGFloat(blurRadius))
        }

        return context
    }
}


extension SDWebImageManager {
    public func loadImage(urlRequest: URLRequest,
                          options: [PSSImageRepositoryImageOptions]?) -> AnyPublisher<PSSImageDownloadEvent, RemoteImageFacadeError> {
        guard let url = urlRequest.url else {
            return Fail(error: RemoteImageFacadeError.missingUrl).eraseToAnyPublisher()
        }

        var context: [SDWebImageContextOption: Any] = options?.cacheKeyContext ?? [:]

        if let headers = urlRequest.allHTTPHeaderFields {
            let customLoader = SDWebImageDownloader()
            headers.forEach { (key, value) in
                customLoader.setValue(value, forHTTPHeaderField: key)
            }
            context[SDWebImageContextOption.imageLoader] = customLoader
        }

        if let cacheKeyOverride = self.cacheKeyOverride(from: options) {
            context[SDWebImageContextOption.cacheKeyFilter] = SDWebImageCacheKeyFilter { _ in
                return cacheKeyOverride
            }
        }

        return ImageLoadStreamBuilder().build(options: options).load(on: self,
                                                                     url: url,
                                                                     options: options,
                                                                     context: context)
    }

    public func loadImageFromCache(urlRequest: URLRequest,
                                   options: [PSSImageRepositoryImageOptions]?) -> PSSImageRepositoryImage? {
        guard let cacheKey = self.cacheKey(for: urlRequest, with: options) else { return nil }

        return self.loadImageFromCache(cacheKey: cacheKey)
    }

    public func loadImageFromCache(cacheKey: String) -> PSSImageRepositoryImage? {
        return (self.imageCache as? SDImageCache)?.imageFromMemoryCache(forKey: cacheKey)
    }

    public func loadDataFromCache(urlRequest: URLRequest, options: [PSSImageRepositoryImageOptions]?) -> AnyPublisher<Data?, Never> {
        guard let cacheKey = self.cacheKey(for: urlRequest, with: options) else {
            return Just(nil).eraseToAnyPublisher()
        }

        return self.loadDataFromCache(cacheKey: cacheKey)
    }

    public func loadDataFromCache(cacheKey: String) -> AnyPublisher<Data?, Never> {
        Deferred {
            Future { promise in
                (self.imageCache as? SDImageCache)?.diskImageDataQuery(forKey: cacheKey,
                                                                       completion: { data in
                    promise(.success(data))
                })
            }
        }.eraseToAnyPublisher()
    }

    public func removeImageFromCache(urlRequest: URLRequest, options: [PSSImageRepositoryImageOptions]?) -> AnyPublisher<Void, Never> {
        guard let cacheKey = self.cacheKey(for: urlRequest, with: options) else { return Just(()).eraseToAnyPublisher() }

        return removeImageFromCache(cacheKey: cacheKey)
    }

    public func removeImageFromCache(cacheKey: String) -> AnyPublisher<Void, Never> {
        return
            Deferred {
                Future<Void, Never> { promise in
                    guard let sdImageCache = self.imageCache as? SDImageCache else {
                        promise(.success(()))
                        return
                    }

                    sdImageCache.removeImage(forKey: cacheKey,
                                             fromDisk: true,
                                             withCompletion: {
                                                promise(.success(()))
                                             })
                }
            }
            .subscribe(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    public func store(for cacheKey: String, image: PSSImageRepositoryImage) -> AnyPublisher<Void, Never> {
        return Deferred {
            Future<Void, Never> { promise in
                // This is a thread-safe implementation of `store` by SDWebImage that utilizes
                // os_unfair_lock
                self.imageCache.store(image,
                                      imageData: nil,
                                      forKey: cacheKey,
                                      cacheType: .all) {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }

    public func store(for urlRequest: URLRequest, options: [PSSImageRepositoryImageOptions]?, data: Data) -> AnyPublisher<Void, RemoteImageFacadeError> {
        guard let cacheKey = self.cacheKey(for: urlRequest, with: options) else {
            return Fail(error: RemoteImageFacadeError.unknownError).eraseToAnyPublisher()
        }

        return store(for: cacheKey, data: data)
            .setFailureType(to: RemoteImageFacadeError.self)
            .eraseToAnyPublisher()
    }

    public func store(for cacheKey: String, data: Data) -> AnyPublisher<Void, Never> {
        return Deferred {
            Future<Void, Never> { promise in
                // This is a thread-safe implementation of `store` by SDWebImage that utilizes
                // os_unfair_lock
                self.imageCache.store(PSSImageRepositoryImage(data: data),
                                      imageData: data,
                                      forKey: cacheKey,
                                      cacheType: .all) {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }

    public func cancelCurrentImageLoad(options: [PSSImageRepositoryImageOptions]?) {
        guard let imageView = options?.targetImageView else {
            return
        }

        imageView.sd_cancelCurrentImageLoad()
    }

    private func cacheKey(for urlRequest: URLRequest, with options: [PSSImageRepositoryImageOptions]?) -> String? {
        return self.cacheKeyOverride(from: options) ?? self.cacheKey(for: urlRequest.url, context: options?.cacheKeyContext)
    }

    private func cacheKeyOverride(from options: [PSSImageRepositoryImageOptions]?) -> String? {
        return options?.compactMap({ (option) -> String? in
            if case .cachedWith(let string) = option {
                return string
            } else if case .cachedWithURL(let url) = option {
                return self.cacheKey(for: url, context: options?.cacheKeyContext)
            } else {
                return nil
            }
        }).first
    }
}

internal final class ImageLoadStreamBuilder {
    func build(options: [PSSImageRepositoryImageOptions]?) -> ImageLoadStreamProviding {
        if options?.targetImageView != nil {
            return UIImageViewStreamBuilder()
        } else {
            return StandardStreamBuilder()
        }
    }
}

internal protocol ImageLoadStreamProviding {
    func load(on imageManager: SDWebImageManager,
              url: URL,
              options: [PSSImageRepositoryImageOptions]?,
              context: [SDWebImageContextOption: Any]) -> AnyPublisher<PSSImageDownloadEvent, RemoteImageFacadeError>
}

/// UIImageView classes have a special extension, sd_setImage, that includes extra functionality
/// including a fade effect when the image loads and a progress bar you can attach that is
/// automatically updated while the image contents download. It also understands placeholder
/// images
internal class UIImageViewStreamBuilder: ImageLoadStreamProviding {
    func load(on imageManager: SDWebImageManager,
              url: URL,
              options: [PSSImageRepositoryImageOptions]?,
              context: [SDWebImageContextOption: Any]) -> AnyPublisher<PSSImageDownloadEvent, RemoteImageFacadeError> {
        guard let imageView = options?.targetImageView else {
            return Fail(error: RemoteImageFacadeError.unknownError).eraseToAnyPublisher()
        }

        // Ensure that any prior operations are cancelled syncronously
        // before starting a new load operation
        imageView.sd_cancelCurrentImageLoad()

        let placeholder = options?.placeholder

        let finalOptions = SDWebImageOptions(options: options ?? [])

        return Deferred { () -> AnyPublisher<PSSImageDownloadEvent, RemoteImageFacadeError> in
            let subject = PassthroughSubject<PSSImageDownloadEvent, RemoteImageFacadeError>()

            precondition(imageView.sd_latestOperationKey == nil)

            imageView.sd_setImage(with: url,
                                  placeholderImage: placeholder,
                                  options: finalOptions,
                                  context: context,
                                  progress: { received, expected, _ in
                subject.send(PSSImageDownloadEvent.progress(percent: Float(received) / Float(expected)))

            },
                                  completed: { image, error, _, _ in
                if let image = image {
                    subject.send(PSSImageDownloadEvent.completed(image: image))
                    subject.send(completion: .finished)
                } else {
                    subject.send(completion: .failure(RemoteImageFacadeError.sdWebImageError(error: error)))
                }
            })

            return subject.eraseToAnyPublisher()
        }
        .handleEvents(receiveCancel: {
            imageView.sd_cancelCurrentImageLoad()
        })
        .eraseToAnyPublisher()
    }
}

/// If you aren't targeting a UIImageView, then we make a standard call directly to the
/// SDWebImageManager. This does not include features like placeholders, fades,
/// and progress bars
internal class StandardStreamBuilder: ImageLoadStreamProviding {
    func load(on imageManager: SDWebImageManager,
              url: URL,
              options: [PSSImageRepositoryImageOptions]?,
              context: [SDWebImageContextOption: Any]) -> AnyPublisher<PSSImageDownloadEvent, RemoteImageFacadeError> {
        var operation: SDWebImageCombinedOperation?
        var finalOptions = SDWebImageOptions(options: options ?? [])
        finalOptions.insert(.queryMemoryData)

        return Deferred { () -> AnyPublisher<PSSImageDownloadEvent, RemoteImageFacadeError> in
            let subject = PassthroughSubject<PSSImageDownloadEvent, RemoteImageFacadeError>()
            operation = imageManager.loadImage(with: url,
                                               options: finalOptions,
                                               context: context,
                                               progress: { received, expected, _ in
                subject.send(PSSImageDownloadEvent.progress(percent: Float(received) / Float(expected)))
            },
                                               completed: { (image, _, error, _, _, _) in
                if let image = image {
                    subject.send(PSSImageDownloadEvent.completed(image: image))
                    subject.send(completion: .finished)
                } else {
                    subject.send(completion: .failure(RemoteImageFacadeError.sdWebImageError(error: error)))
                }
            })

            return subject.eraseToAnyPublisher()
        }
        .handleEvents(receiveCancel: {
            operation?.cancel()
        })
        .eraseToAnyPublisher()
    }
}
