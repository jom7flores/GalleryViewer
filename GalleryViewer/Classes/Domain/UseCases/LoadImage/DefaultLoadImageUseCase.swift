//
//  DefaultLoadImageUseCase.swift
//  GalleryViewer
//
//  Created by Josue Inchaurregui on 1/14/21.
//

import Combine
import UIKit

class DefaultLoadImageUseCase: LoadImageUseCase {

    private let provider: LocalImageProvider

    init(provider: LocalImageProvider) {
        self.provider = provider
    }

    func start(imageId: String) -> AnyPublisher<UIImage?, Never> {
        provider.loadAsset(with: imageId)
    }
}
