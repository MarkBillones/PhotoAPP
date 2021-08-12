//
//  FullScreenViewController.swift
//  MyPhotoApp
//
//  Created by OPSolutions on 8/12/21.
//

import UIKit
import Kingfisher

class FullScreenViewController: UIViewController {
    var imageURL: String!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.kf.setImage(with: URL(string: imageURL))
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
