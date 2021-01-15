//
//  DefaultHomeViewPresenter.swift
//  GalleryViewer
//
//  Created by Josue Flores on 1/12/21.
//

import Combine
import Foundation
import UIKit

enum HomeViewError: Error {
    case notAuthorized
    case unknown
}

class DefaultHomeViewPresenter: HomeViewPresenter {

    private var items: [ImageThumbnail] = []
    private var scale: CGFloat = 1
    private let fetchImagesUseCase: FetchImagesUseCase
    private let authorizePhotosUseCase: AuthorizePhotosUseCase
    private let loadImageUseCase: LoadImageUseCase
    private var cancellables = Set<AnyCancellable>()
    weak var view: HomeView?

    private var favoriteIndexList: [Int] = []

    private(set) var isFavoriteSelected = false
    var sections: Int = 1

    // MARK: - init
    init(
        authorizePhotosUseCase: AuthorizePhotosUseCase,
        fetchImagesUseCase: FetchImagesUseCase,
        loadImageUseCase: LoadImageUseCase
    ) {
        self.fetchImagesUseCase = fetchImagesUseCase
        self.authorizePhotosUseCase = authorizePhotosUseCase
        self.loadImageUseCase = loadImageUseCase
    }

    // MARK: - View attachment
    func attach(view: HomeView) {
        self.view = view
    }

    // MARK: - Life cycle
    func viewDidLoad() {
        authorizePhotosUseCase.start()
            .tryMap { status -> AnyPublisher<Void, Never> in
                switch status {
                case .authorized:
                    return Just(Void()).eraseToAnyPublisher()
                case .denied:
                    throw HomeViewError.notAuthorized
                }
            }
            .flatMap { [weak self] _ -> AnyPublisher<[ImageThumbnail], Error> in
                guard let self = self else {
                    return Result<[ImageThumbnail], Error>
                        .failure(HomeViewError.unknown)
                        .publisher
                        .eraseToAnyPublisher()
                }
                return self.fetchImagesUseCase.start()
            }
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] items in
                self?.handleReceiveItems(items)
            }
            .store(in: &cancellables)
    }

    // MARK: - Data
    func numberOfItems(for section: Int) -> Int {
        return isFavoriteSelected ? favoriteIndexList.count : items.count
    }

    func contentForItem(at indexPath: IndexPath) -> ImageThumbnail {
        let index = isFavoriteSelected ? favoriteIndexList[indexPath.row] : indexPath.row
        if items[index].resourceSubject.value == .none {
            items[index].resourceSubject.send(.loading)
            loadImageUseCase.start(imageId: items[index].id)
                .combineLatest(Just(index), { (image: $0, index: $1) })
                .receive(on: DispatchQueue.main)
                .sink { [weak self] result in
                    self?.handleImageResponse(image: result.image, itemIndex: result.index)
                }
                .store(in: &cancellables)
        }
        return items[index]
    }

    // MARK: - Layout scale
    private(set) var columns: Int = 3
    private var initialUpdateColumns = 0

    func startScaling() {
        initialUpdateColumns = columns
    }

    func scaleUpdate(value: CGFloat) {
        let newColumnCount = Int(CGFloat(initialUpdateColumns) / value)
        guard newColumnCount > 1 && newColumnCount < 12 else {
            return
        }
        guard columns != newColumnCount else {
            return
        }
        columns = newColumnCount
        view?.updateColumnNumber(columns)
    }

    func toggleFavorite() {
        isFavoriteSelected.toggle()

        if items.count > 1000 {
            view?.dataDidLoad()
            return
        }

        if isFavoriteSelected {
            let total = Set(0..<items.count).subtracting(favoriteIndexList)
            view?.performUpdates(.delete(total.map { IndexPath(row: $0, section: 0) }))
        } else {
            let total = Set(0..<items.count).subtracting(favoriteIndexList)
            view?.performUpdates(.add(total.map { IndexPath(row: $0, section: 0) }))
        }
    }

    func toggleFavorite(with id: String) {
        // TODO: Implement add/remove favorite
    }

    // MARK: - Private methods
    private func handleReceiveItems(_ items: [ImageThumbnail]) {
        self.items = items
        view?.dataDidLoad()
        favoriteIndexList = items.enumerated().compactMap { $0.element.isFavorite ? $0.offset : nil }
    }

    private func handleImageResponse(image: UIImage?, itemIndex: Int) {
        items[itemIndex].resourceSubject.send(.loaded(image))
    }
}

// MARK: Layout handling
extension DefaultHomeViewPresenter {
    var elementsSize: CGSize {
        CGSize(width: scale * 120, height: scale * 120)
    }

    func onScaleUpdateReceived(_ scale: CGFloat, bounds: CGRect) {
        self.scale = scale
        self.view?.requestLayoutUpdate()
    }
}
