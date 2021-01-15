//
//  AuthorizePhotosUseCase.swift
//  GalleryViewer
//
//  Created by Josue Flores on 1/13/21.
//

import Combine

protocol AuthorizePhotosUseCase {
    func start() -> AnyPublisher<AuthorizationStatus, Never>
}
