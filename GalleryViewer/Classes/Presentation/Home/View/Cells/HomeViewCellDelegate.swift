//
//  HomeViewCellDelegate.swift
//  GalleryViewer
//
//  Created by Josue Inchaurregui on 1/12/21.
//

import Foundation

protocol HomeViewCellDelegate: class {
    func didToggleFavorite(with id: String)
}
