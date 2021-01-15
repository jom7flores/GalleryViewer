//
//  ThumbnailCell.swift
//  GalleryViewer
//
//  Created by Josue Flores on 1/12/21.
//

import Combine
import UIKit

class ThumbnailCell: UICollectionViewCell, ReusableCell, HomeViewConfigurableCell {

    @IBOutlet var image: UIImageView!
    @IBOutlet var favButton: UIButton!

    weak var delegate: HomeViewCellDelegate?

    private static var heartImage = UIImage(systemName: "heart")
    private static var heartFillImage = UIImage(systemName: "heart.fill")

    private var cancellable: AnyCancellable?
    private var id: String?

    func setup(with model: ImageThumbnail) {
        cancellable?.cancel()
        image.image = model.resourceSubject.value.resource
        cancellable = model.resourceSubject.eraseToAnyPublisher().sink { [weak self] state in
            self?.image.image = state.resource
        }
        favButton.setImage(model.isFavorite ? Self.heartFillImage : Self.heartImage, for: .normal)
        id = model.id
    }

    @IBAction func toggleFavorite() {
        guard let id = id else { return }
        delegate?.didToggleFavorite(with: id)
    }
}
