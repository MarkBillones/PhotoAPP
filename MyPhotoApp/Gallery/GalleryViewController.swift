//
//  File.swift
//  MyPhotoApp
//
//  Created by OPSolutions Billones on 8/11/21.
//

import Foundation
import UIKit

class GalleryViewController: UIViewController {
    private let screenSize = UIScreen.main.bounds
    private let cellIdentifier = "PhotoCollectionViewCell"
    private var photos = [Photo]()  //from private var photos: [Photo] = []
    @IBOutlet weak var collectionView: UICollectionView!
    let filterKeywords = ["1","2","3"]
    var currentFilterIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchPhotos()
        self.navigationItem.title = "Gallery"  //set title programmatically
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        newUserConfiguraton()
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
    
    @IBAction func filterChanged(_ sender: UISegmentedControl) {
        let segmentedControl = sender
        currentFilterIndex =  segmentedControl.selectedSegmentIndex
        
        switch currentFilterIndex {
        case 1:
            view.backgroundColor = .lightGray
        case 2:
            view.backgroundColor = .white
        default:
            view.backgroundColor = .orange
        }
        
        fetchPhotos()
    }
    
    fileprivate func newUserConfiguraton() {
        if Core.shared.isNewUser(){
            //show the onboarding flow
            let viewController = storyboard?.instantiateViewController(identifier: "welcomeViewController") as! WelcomeViewController
            //the newer version of ios, the user can swipe down  your welcome flow
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        }
    }
    
    fileprivate func fetchPhotos() {
        self.collectionView.isHidden = true
        DB.truncate(entityModel: "PhotoModel")
        DB.truncate(entityModel: "UserModel")
        let client = UnsplashAPI()
        client.getPhotos(filterKeywords: filterKeywords[currentFilterIndex]) { (photos: [Photo]?, error: PhotoAPIError?) in
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
                        
                        for photo in self.photos {
                            DB.insertPhoto(photo)
                        }
                    } else {
                        self.photos = [Photo]()
                    }
                }
                self.collectionView.isHidden = false
                self.collectionView.reloadData()
            }
        }
    }
    
    fileprivate func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

//standard View Controller after the Onboarding Flow
class Core {
    
    static let shared = Core()
    
    func isNewUser() -> Bool {//to make it true
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    //once the person has dismissd the welcome flow
    func isNotNewUser() {
        UserDefaults.standard.set(true, forKey: "isNewUser")
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
        return  CGSize(width: screenSize.size.width, height: 400) //custom screen height 300pts
    }
}
