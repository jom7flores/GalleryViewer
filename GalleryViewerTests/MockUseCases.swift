//
//  MockUseCases.swift
//  GalleryViewerTests
//
//  Created by Josue Flores on 1/15/21.
//

import Combine
import UIKit
@testable import GalleryViewer

class MockLoadImageUseCase: LoadImageUseCase {

    private(set) var startCallCount = 0
    private(set) var paramImageIdCount = [String]()
    var result: AnyPublisher<UIImage?, Never>!
    func start(imageId: String) -> AnyPublisher<UIImage?, Never> {
        startCallCount += 1
        paramImageIdCount.append(imageId)
        if result == nil {
            assertionFailure("Result should be initialized")
        }
        return result
    }
}


class MockFetchImagesUseCase: FetchImagesUseCase {

    private(set) var startCallCount = 0
    var result: AnyPublisher<[ImageThumbnail], Error>!
    func start() -> AnyPublisher<[ImageThumbnail], Error> {
        startCallCount += 1
        if result == nil {
            assertionFailure("Result should be initialized")
        }
        return result
    }
}

class MockAuthorizePhotosUseCase: AuthorizePhotosUseCase {

    private(set) var startCallCount = 0
    var result: AnyPublisher<AuthorizationStatus, Never>!
    func start() -> AnyPublisher<AuthorizationStatus, Never> {
        startCallCount += 1
        if result == nil {
            assertionFailure("Result should be initialized")
        }
        return result
    }
}
