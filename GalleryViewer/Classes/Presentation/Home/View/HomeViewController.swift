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

    private var collectionWidth: CGFloat {
        collectionView.safeAreaLayoutGuide.layoutFrame.width
    }
    
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
        
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction))
        collectionView.addGestureRecognizer(gesture)

//        collectionView.collectionViewLayout = GalleryLayout()

        let columns: CGFloat = 3
        let interPadding: CGFloat = 10
        currentSize = (collectionWidth - ((columns - 1) * interPadding)) / columns
    }

    var currentSize: CGFloat = 0

    @IBAction func pinchAction(_ gestureRecognizer : UIPinchGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        // TODO:
    }
    
    @IBAction func toggleFav() {
        presenter.toggleFavorite()

        collectionView.performBatchUpdates { [weak self] in
            switch self?.presenter.itemUpdate() {
            case .add(let items):
                self?.collectionView.insertItems(at: items)
            case .delete(let items):
                self?.collectionView.deleteItems(at: items)
            default:
                break
            }
        } completion: { _ in }
    }
}

extension HomeViewController: HomeView {
    func dataDidLoad(){
        collectionView.reloadData()
    }

    func requestLayoutUpdate() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension HomeViewController: HomeViewCellDelegate {
    func didToggleFavorite(with id: String) {
        presenter.toggleFavorite(with: id)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: currentSize, height: currentSize)
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
            configurable.setup(with: model)
            configurable.delegate = self
        }

        return cell
    }
}
