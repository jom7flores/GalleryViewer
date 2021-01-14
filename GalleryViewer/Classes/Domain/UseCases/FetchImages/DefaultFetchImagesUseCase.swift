//
//  DefaultFetchImagesUseCase.swift
//  GalleryViewer
//
//  Created by Josue Flores on 1/13/21.
//

import Foundation
import Combine

class DefaultFetchImagesUseCase: FetchImagesUseCase {

    private let provider: LocalImageProvider

    init(provider: LocalImageProvider) {
        self.provider = provider
    }
    
    func start() -> AnyPublisher<[ImageThumbnail], Error> {
        Future { promise in
            promise(.success(
                (0...500).map {
                    ImageThumbnail(id: "\($0)", dateAdded: Date(), location: nil, resource: nil, isFavorite: Bool.random())
                }
            ))
        }
        .eraseToAnyPublisher()
    }
}

