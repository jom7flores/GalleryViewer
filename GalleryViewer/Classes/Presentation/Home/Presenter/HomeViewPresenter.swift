//
//  HomeViewPresenter.swift
//  GalleryViewer
//
//  Created by Josue Flores on 1/12/21.
//

import Foundation

protocol HomeViewPresenter {

    func attach(view: HomeView)
    func viewDidLoad()

    var sections: Int { get }
    func numberOfItems(for section: Int) -> Int
    func contentForItem(at indexPath: IndexPath) -> ImageThumbnail
}
