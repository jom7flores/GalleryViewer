//
//  LoadableViewController.swift
//  GalleryViewer
//
//  Created by Josue Flores on 1/12/21.
//

import Foundation
import UIKit

protocol LoadableViewController {
    associatedtype Presenter

    static var viewId: String { get }
    init?(presenter: Presenter, coder: NSCoder)
}

extension LoadableViewController where Self: UIViewController {

    static var viewId: String { String(describing: Self.self) }
    static var storyboardName: String { viewId.replacingOccurrences(of: "ViewController", with: "") }

    static func instantiate(presenter: Presenter, bundle: Bundle? = nil) -> Self {
        let storyboard = UIStoryboard(name: Self.storyboardName, bundle: bundle)
        return storyboard.instantiateViewController(identifier: Self.viewId) {
            Self(presenter: presenter, coder: $0)
        }
    }
}
