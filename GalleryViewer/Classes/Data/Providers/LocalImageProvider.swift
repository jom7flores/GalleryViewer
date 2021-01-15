//
//  LocalImageProvider.swift
//  GalleryViewer
//
//  Created by Josue Flores on 1/13/21.
//

import Combine
import Photos
import UIKit

protocol LocalImageProvider {
    func requestMediaAccess() -> AnyPublisher<PHAuthorizationStatus, Never>
    func fetchAssets() -> AnyPublisher<[PHAsset], Error>
    func loadAsset(with identifier: String, mode: ImageProviderLoadingMode, targetSize: CGSize) -> AnyPublisher<UIImage?, Never>
}
