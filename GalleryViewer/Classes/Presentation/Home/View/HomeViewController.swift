//
//  HomeViewController.swift
//  GalleryViewer
//
//  Created by Josue Flores on 1/12/21.
//

import UIKit

class HomeViewController: UIViewController, LoadableViewController {

    @IBOutlet var collectionView: UICollectionView!

    let presenter: HomeViewPresenter

    required init?(presenter: HomeViewPresenter, coder: NSCoder) {
        self.presenter = presenter
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(ThumbnailCell.self)
        presenter.attach(view: self)
        presenter.viewDidLoad()
    }


}

extension HomeViewController: HomeView {
    func dataDidLoad(){
        collectionView.reloadData()
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        presenter.sections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfItems(for: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbnailCell.reuseId, for: indexPath)
        let model = presenter.contentForItem(at: indexPath)

        if let configurable = cell as? HomeViewConfigurableCell {
            configurable.setup(with: model)
        }

        return cell
    }
}
