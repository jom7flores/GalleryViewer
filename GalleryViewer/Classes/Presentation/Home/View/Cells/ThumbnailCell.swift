//
//  ThumbnailCell.swift
//  GalleryViewer
//
//  Created by Josue Flores on 1/12/21.
//

import UIKit

class ThumbnailCell: UICollectionViewCell, ReusableCell, HomeViewConfigurableCell {

    @IBOutlet var image: UIImageView!

    func setup(with model: ImageThumbnail) {
        image.image = model.resource
    }
}
