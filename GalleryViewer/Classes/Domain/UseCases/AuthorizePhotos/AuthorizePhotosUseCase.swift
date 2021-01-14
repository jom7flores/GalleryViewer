//
//  AuthorizePhotosUseCase.swift
//  GalleryViewer
//
//  Created by Josue Inchaurregui on 1/13/21.
//

import Combine

protocol AuthorizePhotosUseCase {
    func start() -> AnyPublisher<AuthorizationStatus, Never>
}
