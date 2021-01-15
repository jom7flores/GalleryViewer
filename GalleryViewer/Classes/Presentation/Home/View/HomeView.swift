//
//  HomeView.swift
//  GalleryViewer
//
//  Created by Josue Flores on 1/12/21.
//

import Foundation

protocol HomeView: class {
    func dataDidLoad()
    func requestLayoutUpdate()
    func reloadItem(at indexPath: IndexPath)
    func performUpdates(_ update: Update)
    func updateColumnNumber(_ columns: Int)
}
