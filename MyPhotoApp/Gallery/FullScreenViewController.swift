//
//  FullScreenViewController.swift
//  MyPhotoApp
//
//  Created by OPSolutions Billones on 8/11/21.
//

import UIKit
import Kingfisher

class FullScreenViewController: UIViewController {
    var imageURL: String!
    var imageDesc: String!
    
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.kf.setImage(with: URL(string: imageURL))
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
}
