//
//  ImageSearchViewController.swift
//  MyPhotoApp
//
//  Created by OPSolutions on 8/15/21.
//

import UIKit

class ImageSearchViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate, UICollectionViewDelegate {
    
    private var collectionView: UICollectionView?
    var results: [Results] = []
    let searchbar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfiguration()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchbar.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.frame.size.width-20, height: 50)
        collectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top+55, width: view.frame.size.width, height: view.frame.size.height-55)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchbar.resignFirstResponder()
        if let text = searchbar.text {
            results = []
            collectionView?.reloadData()
            fetchPhotos(query: text)
        }
    }
    
    fileprivate func viewConfiguration() {
        searchbar.delegate = self
        view.addSubview(searchbar)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.frame.width/2, height: view.frame.width/2)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        self.collectionView = collectionView
    }
    
    func fetchPhotos(query: String) {
        let referenceURL = "\(baseURL)\(searchParameters)\(query)\(clientID)"
        
        guard let url = URL(string: referenceURL) else {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}
