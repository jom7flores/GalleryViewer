//
//  HomeView.swift
//  GalleryViewer
//
//  Created by Josue Flores on 1/12/21.
//

import Foundation
import UIKit

protocol HomeView: class {
    /// Notifies when a reload on the view is needed
    func dataDidLoad()
    /// Notifies when a reload on the view layout is needed
    func requestLayoutUpdate(itemSize: CGSize)
    /// Notifies when a reload on for either add or delete specific IndexPath on the view
    func performUpdates(_ update: Update)
}

/// View update requested by presenter
enum Update {
    case add([IndexPath])
    case delete([IndexPath])
}
