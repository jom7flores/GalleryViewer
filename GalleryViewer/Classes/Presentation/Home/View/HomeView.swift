//
//  HomeView.swift
//  GalleryViewer
//
//  Created by Josue Flores on 1/12/21.
//

import Foundation
import UIKit

protocol HomeView: class {
    func dataDidLoad()
    func requestLayoutUpdate(itemSize: CGSize)
    func reloadItem(at indexPath: IndexPath)
    func performUpdates(_ update: Update)
}
