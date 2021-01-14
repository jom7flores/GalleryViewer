//
//  ThumbnailCell.swift
//  GalleryViewer
//
//  Created by Josue Flores on 1/12/21.
//

import UIKit

class ThumbnailCell: UICollectionViewCell, ReusableCell, HomeViewConfigurableCell {

    @IBOutlet var image: UIImageView!
    @IBOutlet var favButton: UIButton!

    weak var delegate: HomeViewCellDelegate?

    static var heartImage = UIImage(systemName: "heart")
    static var heartFillImage = UIImage(systemName: "heart.fill")

    private var id: String?

    func setup(with model: ImageThumbnail) {
        image.image = model.resource
        favButton.setImage(model.isFavorite ? Self.heartFillImage : Self.heartImage, for: .normal)
        id = model.id
    }

    @IBAction func toggleFavorite() {
        guard let id = id else { return }
        delegate?.didToggleFavorite(with: id)
    }
}
