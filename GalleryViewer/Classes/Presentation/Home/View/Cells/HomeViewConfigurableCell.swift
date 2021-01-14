//
//  HomeViewConfigurableCell.swift
//  GalleryViewer
//
//  Created by Josue Flores on 1/12/21.
//

import Foundation

protocol HomeViewConfigurableCell {
    func setup(with model: ImageThumbnail)
    var delegate: HomeViewCellDelegate? { get set }
}
