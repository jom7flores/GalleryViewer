//
//  HomeViewPresenterTests.swift
//  GalleryViewerTests
//
//  Created by Josue Flores on 1/15/21.
//

import Combine
import XCTest
@testable import GalleryViewer

class HomeViewPresenterTests: XCTestCase {

    private var sut: HomeViewPresenter!
    private var mockHomeView: MockHomeView!
    private var mockLoadImageUseCase: MockLoadImageUseCase!
    private var mockFetchImagesUseCase: MockFetchImagesUseCase!
    private var mockAuthorizePhotosUseCase: MockAuthorizePhotosUseCase!

    private var listThumbnails: [ImageThumbnail] {
        [
            .init(id: "1", dateAdded: nil, location: nil, resourceState: .none, isFavorite: false),
            .init(id: "1", dateAdded: nil, location: nil, resourceState: .none, isFavorite: false),
            .init(id: "1", dateAdded: nil, location: nil, resourceState: .none, isFavorite: true),
            .init(id: "1", dateAdded: nil, location: nil, resourceState: .none, isFavorite: false),
            .init(id: "1", dateAdded: nil, location: nil, resourceState: .none, isFavorite: true)
        ]
    }
    
    override func setUpWithError() throws {
        mockHomeView = .init()
        mockLoadImageUseCase = .init()
        mockFetchImagesUseCase = .init()
        mockAuthorizePhotosUseCase = .init()

        sut = DefaultHomeViewPresenter(
            authorizePhotosUseCase: mockAuthorizePhotosUseCase,
            fetchImagesUseCase: mockFetchImagesUseCase,
            loadImageUseCase: mockLoadImageUseCase
        )
    }

    override func tearDownWithError() throws {
        mockHomeView = nil
        mockLoadImageUseCase = nil
        mockFetchImagesUseCase = nil
        mockAuthorizePhotosUseCase = nil
    }

    func test_viewDidLoad_SHOULD_call_FetchImagesUseCase_AND_call_dataDidLoad() {
        mockAuthorizePhotosUseCase.result = Just(AuthorizationStatus.authorized)
            .eraseToAnyPublisher()
        mockFetchImagesUseCase.result = Just([ImageThumbnail]())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        sut.attach(view: mockHomeView)

        sut.viewDidLoad()

        let expectation = XCTestExpectation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(mockFetchImagesUseCase.startCallCount, 1)
        XCTAssertEqual(mockHomeView.dataDidLoadCallCount, 1)
    }

    func test_toggleFavorite_TO_true_SHOULD_send_delete_update() {
        mockAuthorizePhotosUseCase.result = Just(AuthorizationStatus.authorized)
            .eraseToAnyPublisher()
        mockFetchImagesUseCase.result = Just(listThumbnails)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        let indexPathNotFav = listThumbnails.enumerated().compactMap { !$0.element.isFavorite ? $0.offset : nil }
            .map { IndexPath(row: $0, section: 0) }

        sut.attach(view: mockHomeView)

        sut.viewDidLoad()

        let expectation = XCTestExpectation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        sut.toggleFavorite()

        guard case let .delete(indexPaths)? = mockHomeView.performUpdatesParamUpdate.first else {
            XCTFail("Should send delete event when favorite is enabled")
            return
        }

        XCTAssertEqual(indexPaths.sorted(), indexPathNotFav.sorted())
    }

    func test_toggleFavorite_TO_false_SHOULD_send_add_update() {
        mockAuthorizePhotosUseCase.result = Just(AuthorizationStatus.authorized)
            .eraseToAnyPublisher()
        mockFetchImagesUseCase.result = Just(listThumbnails)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        let indexPathNotFav = listThumbnails.enumerated().compactMap { !$0.element.isFavorite ? $0.offset : nil }
            .map { IndexPath(row: $0, section: 0) }

        sut.attach(view: mockHomeView)

        sut.viewDidLoad()

        let expectation = XCTestExpectation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)

        sut.toggleFavorite()
        sut.toggleFavorite()

        guard case let .add(indexPaths)? = mockHomeView.performUpdatesParamUpdate.last else {
            XCTFail("Should send delete event when favorite is enabled")
            return
        }

        XCTAssertEqual(indexPaths.sorted(), indexPathNotFav.sorted())
    }

}
