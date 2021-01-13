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
        navigationController?.pushViewController(HomeViewController.instantiate(presenter: DefaultHomeViewPresenter()),
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
