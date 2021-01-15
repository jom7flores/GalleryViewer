//
//  DefaultFetchImagesUseCase.swift
//  GalleryViewer
//
//  Created by Josue Flores on 1/13/21.
//

import Foundation
import Combine
import Photos

class DefaultFetchImagesUseCase: FetchImagesUseCase {

    private let provider: LocalImageProvider

    init(provider: LocalImageProvider) {
        self.provider = provider
    }

    func start() -> AnyPublisher<[ImageThumbnail], Error> {
        provider.fetchAssets()
            .map { $0.map { $0.mapToImageThumbnail } }
            .eraseToAnyPublisher()
    }
}

extension PHAsset {
    var mapToImageThumbnail: ImageThumbnail {
        ImageThumbnail(
            id: localIdentifier,
            dateAdded: creationDate,
            location: location?.coordinate,
            resourceState: .none,
            isFavorite: isFavorite
        )
    }
}
