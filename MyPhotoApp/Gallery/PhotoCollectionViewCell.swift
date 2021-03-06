//
//  PhotoCollectionViewCell.swift
//  MyPhotoApp
//
//  Created by OPSolutions Billones on 8/11/21.
//

import UIKit
import Kingfisher

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    static let identifier = "PhotoCollectionViewCell"
    
    var photo: Photo! {
        didSet {
            self.descriptionLabel.text = photo.description ?? "BetterMarkPhotography"//
            
            guard let url = URL(string: photo.urls.regular) else {
                return
            }
            self.imageView.kf.setImage(with: url)
        }
    }
}
