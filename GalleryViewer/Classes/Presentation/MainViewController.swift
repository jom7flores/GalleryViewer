//
//  MainViewController.swift
//  GalleryViewer
//
//  Created by Josue Flores on 1/12/21.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mediaProvider = DefaultLocalImageProvider()
        setViewControllers(
            [
                HomeViewController.instantiate(
                    presenter: DefaultHomeViewPresenter(
                        authorizePhotosUseCase: DefaultAuthorizePhotosUseCase(provider: mediaProvider),
                        fetchImagesUseCase: DefaultFetchImagesUseCase(provider: mediaProvider),
                        loadImageUseCase: DefaultLoadImageUseCase(provider: mediaProvider)
                    )
                )
            ],
            animated: false
        )
    }
}
