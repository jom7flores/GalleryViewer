//
//  HomeViewPresenter.swift
//  GalleryViewer
//
//  Created by Josue Flores on 1/12/21.
//

import Foundation
import UIKit

protocol HomeViewPresenter {

    func attach(view: HomeView)
    func viewDidLoad()

    func toggleFavorite()
    func toggleFavorite(with id: String)
    func onScaleUpdateReceived(_ scale: CGFloat, bounds: CGRect)
    func itemUpdate() -> Update

    var elementsSize: CGSize { get }
    var sections: Int { get }
    func numberOfItems(for section: Int) -> Int
    func contentForItem(at indexPath: IndexPath) -> ImageThumbnail
}

enum Update {
    case add([IndexPath])
    case delete([IndexPath])
}
