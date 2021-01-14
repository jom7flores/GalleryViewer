//
//  FetchImagesUseCase.swift
//  GalleryViewer
//
//  Created by Josue Flores on 1/13/21.
//

import Combine

protocol FetchImagesUseCase {
    func start() -> AnyPublisher<[ImageThumbnail], Error>
}
