//
//  DefaultHomeViewPresenter.swift
//  GalleryViewer
//
//  Created by Josue Flores on 1/12/21.
//

import Combine
import Foundation
import UIKit

class DefaultHomeViewPresenter: HomeViewPresenter {

    private var items: [ImageThumbnail] = []
    private var scale: CGFloat = 1
    private var isFavoriteSelected = false
    private let fetchImagesUseCase: FetchImagesUseCase
    private var cancellables = Set<AnyCancellable>()
    weak var view: HomeView?

    private var favoriteIndex: [Int] = []

    var sections: Int = 1

    // MARK: - init
    init(fetchImagesUseCase: FetchImagesUseCase) {
        self.fetchImagesUseCase = fetchImagesUseCase
    }

    // MARK: - View attachment
    func attach(view: HomeView) {
        self.view = view
    }

    // MARK: - Life cycle
    func viewDidLoad() {
        fetchImagesUseCase.start()
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] items in
                self?.handleReceiveItems(items)
            }
            .store(in: &cancellables)
    }

    // MARK: - Data
    func numberOfItems(for section: Int) -> Int {
        return isFavoriteSelected ? favoriteIndex.count : items.count
    }

    func contentForItem(at indexPath: IndexPath) -> ImageThumbnail {
        isFavoriteSelected ? items[favoriteIndex[indexPath.row]] : items[indexPath.row]
    }

    func itemUpdate() -> Update {
        if isFavoriteSelected {
            let total = Set(0..<items.count).subtracting(favoriteIndex)
            return .delete(total.map { IndexPath(row: $0, section: 0) })
        } else {
            let total = Set(0..<items.count).subtracting(favoriteIndex)
            return .add(total.map { IndexPath(row: $0, section: 0) })
        }
    }

    func toggleFavorite() {
        isFavoriteSelected.toggle()
    }

    func toggleFavorite(with id: String) {
        // TODO: Implement add/remove favorite
    }

    // MARK: - Private methods
    private func handleReceiveItems(_ items: [ImageThumbnail]) {
        self.items = items
        view?.dataDidLoad()
        favoriteIndex = items.enumerated().compactMap { $0.element.isFavorite ? $0.offset : nil }
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
