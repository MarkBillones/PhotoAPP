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
    private let cellIdentifier = "PhotoCollectionViewCell"
    private var photos = [Photo]()  //from private var photos: [Photo] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate func networkFetching() {
        let network = Networking()
        network.fetch(resource: "photos", model: Photo.self) { results in
            self.photos = results as! [Photo]
            self.collectionView.reloadData()
            print(results)
        }
    }
    
    fileprivate func loadPhotos() {
        let client = UnsplashAPI()
        client.getPhotos { (photos: [Photo]?, error: PhotoAPIError?) in
            DispatchQueue.main.async {
                if let error = error {
                    // show alert
                    print(error)
                    
                    switch error {
                    case .apiFailed(let message):
                        print(message)
                    case .parsingFailed(let message):
                        print(message)
                    }
                } else {
                    if let photos = photos {
                        self.photos = photos
                    } else {
                        self.photos = [Photo]()
                    }
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    fileprivate func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        loadPhotos()
        //networkFetching()
        self.navigationItem.title = "Gallery"  //set title programmatically
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "segueToFullScreen" else {
            return
        }
        
        let fullScreenVC = segue.destination as! FullScreenViewController
        
        guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems,
              let selectedIndexPath = selectedIndexPaths.first else {
            return
        }

        let photo = photos[selectedIndexPath.row]
        fullScreenVC.imageURL = photo.urls.regular
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    //sizeforitem
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: screenSize.size.width, height: 300)
        //screenSize.size.width
    }
}
