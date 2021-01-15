//
//  HomeViewPresenter.swift
//  GalleryViewer
//
//  Created by Josue Flores on 1/12/21.
//

import Foundation
import UIKit

protocol HomeViewPresenter {

    /// View attachment to presenter
    func attach(view: HomeView)
    /// Must be call to indicate view has loaded
    func viewDidLoad()

    /// Expose favorite state
    var isFavoriteSelected: Bool { get }
    /// Send action when favorite state change is requested
    func toggleFavorite()
    /// Send action to change favorite state in particular Image
    func toggleFavorite(with id: String)

    /// Reset state of scalling to begin new one
    func startScaling()
    /// Receiving scale update
    func scaleUpdate(value: CGFloat)
    /// Notify when the view modifies its size (device rotation)
    func willModifyViewSize(size: CGSize)

    /// Size of the items in the view
    var elementsSize: CGSize { get }
    /// Number of sections to show
    var sections: Int { get }
    /// Number of items in each section
    func numberOfItems(for section: Int) -> Int
    /// Item Model at especific indexPath
    func contentForItem(at indexPath: IndexPath) -> ImageThumbnail
}
