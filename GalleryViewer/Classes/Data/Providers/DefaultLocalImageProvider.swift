//
//  DefaultLocalImageProvider.swift
//  GalleryViewer
//
//  Created by Josue Flores on 1/13/21.
//

import Combine
import Photos
import UIKit

class DefaultLocalImageProvider: LocalImageProvider {

    let imageLoadQueue: DispatchQueue
    
    init() {
        imageLoadQueue = DispatchQueue(label: "imageLoadingThread", qos: .userInitiated)
    }

    var status: PHAuthorizationStatus {
        if #available(iOS 14, *) {
            return PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            return PHPhotoLibrary.authorizationStatus()
        }
    }

    func requestMediaAccess() -> AnyPublisher<PHAuthorizationStatus, Never> {
        guard status == .notDetermined else {
            return Just(status).eraseToAnyPublisher()
        }

        return Future<PHAuthorizationStatus, Never> { promise in
            DispatchQueue.main.async {
                if #available(iOS 14, *) {
                    PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                        promise(.success(status))
                    }
                } else {
                    PHPhotoLibrary.requestAuthorization { status in
                        promise(.success(status))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }

    func fetchAssets() -> AnyPublisher<[PHAsset], Error> {
        guard status == .authorized else {
            return Fail(outputType: [PHAsset].self, failure: ImageProviderError.notAuthorized)
                .eraseToAnyPublisher()
        }
        return Future { promise in
            DispatchQueue.global().async {
                let options = PHFetchOptions()
                options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                options.predicate = NSPredicate(format: "mediaType == %ld", PHAssetMediaType.image.rawValue)
                let result = PHAsset.fetchAssets(with: options)
                promise(.success(result.objects(at: IndexSet(0..<result.count))))
            }
        }
        .eraseToAnyPublisher()
    }

    func loadAsset(with identifier: String, mode: ImageProviderLoadingMode, targetSize: CGSize) -> AnyPublisher<UIImage?, Never> {
        let value = PassthroughSubject<UIImage?, Never>()

        imageLoadQueue.async { [value] in
            let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil)
            guard let phAsset = fetchResult.firstObject else {
                return
            }
            let options = PHImageRequestOptions()
            options.version = .current
            options.resizeMode = mode == .fast ? .fast : .exact
            options.deliveryMode = mode == .fast ? .opportunistic : .highQualityFormat
            options.isNetworkAccessAllowed = true

            PHImageManager.default().requestImage(
                for: phAsset,
                targetSize: targetSize,
                contentMode: .aspectFill,
                options: options
            ) { image, _ in
                value.send(image)
            }
        }

        return value.eraseToAnyPublisher()
    }
}

enum ImageProviderError: Error {
    case notAuthorized
}

enum ImageProviderLoadingMode {
    case fast
    case exact
}
