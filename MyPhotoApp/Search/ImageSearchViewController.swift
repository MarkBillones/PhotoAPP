//
//  ImageSearchViewController.swift
//  MyPhotoApp
//
//  Created by OPSolutions on 8/15/21.
//

import UIKit

class ImageSearchViewController: UIViewController, UICollectionViewDataSource {

    private var collectionView: UICollectionView?
    var results: [Results] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.frame.width/2, height: view.frame.width/2)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.dataSource = self
        view.addSubview(collectionView)
        self.collectionView = collectionView
        fetchPhotos()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
        //collectionView?.reloadData()
    }

    func fetchPhotos() {
        self.collectionView?.isHidden = true
        
        guard let url = URL(string: searchBaseURL) else {
            return
        }
        //
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let jsonResult = try JSONDecoder().decode(APIResponce.self, from: data)
                print(jsonResult.results.count)
                //unwrap it in dispatchqueue
                DispatchQueue.main.async {
                    self?.results = jsonResult.results
                    self?.collectionView?.reloadData()
                }

            }catch {
                print("Error!")
            }
        }
        self.collectionView?.isHidden = false
        task.resume()
    }

    //Type 'ViewController'conform to protocol 'UICollectionView', so this is a conformance of ViewController
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageURLString = results[indexPath.row].urls.regular
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: imageURLString)
        cell.backgroundColor = .orange
        return cell
    }

}
