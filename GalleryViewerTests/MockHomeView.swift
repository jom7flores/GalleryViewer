//
//  MockHomeView.swift
//  GalleryViewerTests
//
//  Created by Josue Flores on 1/15/21.
//

import Foundation
import UIKit
@testable import GalleryViewer

class MockHomeView: HomeView {

    private(set) var dataDidLoadCallCount = 0
    func dataDidLoad() {
        dataDidLoadCallCount += 1
    }

    private(set) var requestLayoutUpdateCallCount = 0
    private(set) var requestLayoutUpdateParamItemSize = [CGSize]()
    func requestLayoutUpdate(itemSize: CGSize) {
        reloadItemCallCount += 1
        requestLayoutUpdateParamItemSize.append(itemSize)
    }

    private(set) var reloadItemCallCount = 0
    private(set) var reloadItemParamIndexPath = [IndexPath]()
    func reloadItem(at indexPath: IndexPath) {
        reloadItemCallCount += 1
        reloadItemParamIndexPath.append(indexPath)
    }

    private(set) var performUpdatesCallCount = 0
    private(set) var performUpdatesParamUpdate = [Update]()
    func performUpdates(_ update: Update) {
        performUpdatesCallCount += 1
        performUpdatesParamUpdate.append(update)
    }

}
