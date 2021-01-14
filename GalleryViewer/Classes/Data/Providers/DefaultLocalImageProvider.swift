//
//  DefaultLocalImageProvider.swift
//  GalleryViewer
//
//  Created by Josue Inchaurregui on 1/13/21.
//

import Combine
import Photos

class DefaultLocalImageProvider: LocalImageProvider {

    func requestMediaAccess() -> AnyPublisher<PHAuthorizationStatus, Never> {
        let status: PHAuthorizationStatus
        if #available(iOS 14, *) {
            status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            status = PHPhotoLibrary.authorizationStatus()
        }

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
        Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

}
