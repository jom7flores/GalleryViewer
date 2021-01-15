//
//  MainViewController.swift
//  GalleryViewer
//
//  Created by Josue Flores on 1/12/21.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func moevete() {
        let mediaProvider = DefaultLocalImageProvider()
        navigationController?.pushViewController(
            HomeViewController.instantiate(
                presenter: DefaultHomeViewPresenter(
                    authorizePhotosUseCase: DefaultAuthorizePhotosUseCase(provider: mediaProvider),
                    fetchImagesUseCase: DefaultFetchImagesUseCase(provider: mediaProvider),
                    loadImageUseCase: DefaultLoadImageUseCase(provider: mediaProvider)
                )),
            animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
