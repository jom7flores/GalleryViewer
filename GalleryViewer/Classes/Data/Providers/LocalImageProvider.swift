//
//  LocalImageProvider.swift
//  GalleryViewer
//
//  Created by Josue Inchaurregui on 1/13/21.
//

import Combine
import Photos

protocol LocalImageProvider {
    func requestMediaAccess() -> AnyPublisher<PHAuthorizationStatus, Never>
    func fetchAssets() -> AnyPublisher<[PHAsset], Error>
}
