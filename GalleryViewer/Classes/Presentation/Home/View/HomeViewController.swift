//
//  HomeViewController.swift
//  GalleryViewer
//
//  Created by Josue Flores on 1/12/21.
//

import UIKit

class HomeViewController: UIViewController, LoadableViewController {

    @IBOutlet var collectionView: UICollectionView!
    var favoriteButton: UIButton!

    let presenter: HomeViewPresenter

    private var collectionSize: CGSize {
        collectionView.safeAreaLayoutGuide.layoutFrame.size
    }

    required init?(presenter: HomeViewPresenter, coder: NSCoder) {
        self.presenter = presenter
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private static var heartImage = UIImage(systemName: "heart")
    private static var heartFillImage = UIImage(systemName: "heart.fill")

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(ThumbnailCell.self)

        let favoriteButton = UIButton()
        favoriteButton.setImage(presenter.isFavoriteSelected ? Self.heartFillImage : Self.heartImage,
                                for: .normal)
        favoriteButton.addTarget(self, action: #selector(toggleFav), for: .touchUpInside)
        navigationItem.rightBarButtonItem = .init(customView: favoriteButton)
        self.favoriteButton = favoriteButton

        presenter.attach(view: self)
        presenter.viewDidLoad()

        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction))
        collectionView.addGestureRecognizer(gesture)

        presenter.willModifyViewSize(size: collectionSize)

        navigationController?.hidesBarsOnSwipe = true
    }
 
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: nil) { [weak self] _ in
            guard let self = self else { return }
            self.presenter.willModifyViewSize(size: self.collectionSize)
        }
    }

    // MARK: - Actions
    @IBAction func pinchAction(_ gestureRecognizer : UIPinchGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }

        switch gestureRecognizer.state {
        case .began:
            presenter.startScaling()
        case .changed:
            presenter.scaleUpdate(value: gestureRecognizer.scale)
        default:
            break
        }
    }

    @IBAction func toggleFav() {
        presenter.toggleFavorite()
        favoriteButton.setImage(presenter.isFavoriteSelected ? Self.heartFillImage : Self.heartImage,
                                for: .normal)        
    }
}

extension HomeViewController: HomeView {
    func dataDidLoad() {
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    func requestLayoutUpdate(itemSize: CGSize) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = itemSize
        collectionView.setCollectionViewLayout(layout, animated: true)
    }

    func reloadItem(at indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }

    func performUpdates(_ update: Update) {
        collectionView.performBatchUpdates { [weak self] in
            switch update {
            case .add(let items):
                self?.collectionView.insertItems(at: items)
            case .delete(let items):
                self?.collectionView.deleteItems(at: items)
            }
        } completion: { _ in }
    }
}

extension HomeViewController: HomeViewCellDelegate {
    func didToggleFavorite(with id: String) {
        presenter.toggleFavorite(with: id)
    }
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

        if var configurable = cell as? HomeViewConfigurableCell {
            configurable.delegate = self
            configurable.setup(with: model)
        }

        return cell
    }
}
