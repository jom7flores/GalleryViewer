//
//  DefaultHomeViewPresenter.swift
//  GalleryViewer
//
//  Created by Josue Flores on 1/12/21.
//

import Foundation

class DefaultHomeViewPresenter: HomeViewPresenter {

    weak var view: HomeView?

    func attach(view: HomeView) {
        self.view = view
    }

    // MARK: - Data source
    private var items = 0
    var sections: Int { 1 }

    func numberOfItems(for section: Int) -> Int {
        return items
    }

    func contentForItem(at indexPath: IndexPath) -> ImageThumbnail {
        ImageThumbnail(id: "", dateAdded: Date(), location: nil, resource: nil)
    }

    func viewDidLoad() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.items = 500
            self.view?.dataDidLoad()
        }
    }
}
