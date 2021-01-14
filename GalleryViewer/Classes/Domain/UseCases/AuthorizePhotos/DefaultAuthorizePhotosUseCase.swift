//
//  DefaultAuthorizePhotosUseCase.swift
//  GalleryViewer
//
//  Created by Josue Inchaurregui on 1/13/21.
//

import Combine

class DefaultAuthorizePhotosUseCase: AuthorizePhotosUseCase {

    private let provider: LocalImageProvider

    init(provider: LocalImageProvider) {
        self.provider = provider
    }

    func start() -> AnyPublisher<AuthorizationStatus, Never> {
        provider.requestMediaAccess()
            .map {
                switch $0 {
                case .authorized:
                    return AuthorizationStatus.authorized
                default:
                    return AuthorizationStatus.denied
                }
            }
            .eraseToAnyPublisher()
    }
}
