//
//  File.swift
//  MyPhotoApp
//
//  Created by OPSolutions on 8/11/21.
//

import Foundation
import UIKit

class GalleryViewController: UIViewController {
    private let screenSize = UIScreen.main.bounds
    private let cellIdentifier = "PhotoCell"
    private var photos: [Photo] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Gallery"  //set title programmatically
        collectionViewLayout()
        networkFetching()
    }
    
    fileprivate func networkFetching() {
        let network = Networking()
        network.fetch(resource: "photos", model: Photo.self) { results in
            self.photos = results as! [Photo]
            self.collectionView.reloadData()
            print(results)
        }
    }
    
    fileprivate func collectionViewLayout() {
        
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical

        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.view.addSubview(collectionView)
    }
    
}

extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo = photos[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PhotoCollectionViewCell
        cell.photo = photo
        return cell
    }
}

extension GalleryViewController: UICollectionViewDelegate {
    
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    //sizeforitem
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: screenSize.size.width , height: 280)
    }
}
