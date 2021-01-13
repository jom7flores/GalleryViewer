//
//  ReusableCell.swift
//  GalleryViewer
//
//  Created by Josue Flores on 1/12/21.
//

import UIKit

protocol ReusableCell {
    static var reuseId: String { get }
}

extension ReusableCell where Self: UICollectionViewCell {
    static var reuseId: String {
        String(describing: Self.self)
    }
}

extension UICollectionView {
    func register(_ reusableCell: ReusableCell.Type, from bundle: Bundle? = .main) {
        register(UINib(nibName: reusableCell.reuseId, bundle: bundle),
                 forCellWithReuseIdentifier: reusableCell.reuseId)
    }
}
