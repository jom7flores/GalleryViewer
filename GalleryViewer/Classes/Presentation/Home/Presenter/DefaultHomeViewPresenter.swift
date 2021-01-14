//
//  DefaultHomeViewPresenter.swift
//  GalleryViewer
//
//  Created by Josue Flores on 1/12/21.
//

import Foundation
import UIKit

class DefaultHomeViewPresenter: HomeViewPresenter {

    weak var view: HomeView?

    func attach(view: HomeView) {
        self.view = view
    }

    private var items: [ImageThumbnail] = []
    private var isFavoriteSelected = false
    
    // MARK: - Data source
    var sections: Int { 1 }
    var scale: CGFloat = 1

    func numberOfItems(for section: Int) -> Int {
        return isFavoriteSelected ? favoriteIndex.count : items.count
    }

    func contentForItem(at indexPath: IndexPath) -> ImageThumbnail {
        isFavoriteSelected ? items[favoriteIndex[indexPath.row]] : items[indexPath.row]
    }

    var favoriteIndex: [Int] = []

    func itemUpdate() -> Update {
        if isFavoriteSelected {
            let total = Set(0..<items.count).subtracting(favoriteIndex)
            return .delete(total.map { IndexPath(row: $0, section: 0) })
        } else {
            let total = Set(0..<items.count).subtracting(favoriteIndex)
            return .add(total.map { IndexPath(row: $0, section: 0) })
        }
    }

    func viewDidLoad() {
        self.items = (0...500).map {
            ImageThumbnail(id: "\($0)", dateAdded: Date(), location: nil, resource: nil, isFavorite: Bool.random())
        }
        self.view?.dataDidLoad()
        favoriteIndex = items.enumerated().compactMap { $0.element.isFavorite ? $0.offset : nil }
    }

    func toggleFavorite() {
        isFavoriteSelected.toggle()
    }

    func toggleFavorite(with id: String) {
        // TODO: Implement add/remove favorite 
    }

    var elementsSize: CGSize {
        CGSize(width: scale * 120, height: scale * 120)
    }

    func onScaleUpdateReceived(_ scale: CGFloat, bounds: CGRect) {
        self.scale = scale
        self.view?.requestLayoutUpdate()
    }
}
