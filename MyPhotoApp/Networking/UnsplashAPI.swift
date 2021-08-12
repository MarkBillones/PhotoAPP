//
//  UnsplashAPI.swift
//  MyPhotoApp
//
//  Created by OPSolutions on 8/11/21.
//

import Foundation

struct UnsplashAPIEndopints {
    static let photos = "photos"
}

enum PhotoAPIError: Error {
    case apiFailed(String)
    case parsingFailed(String)
}

class UnsplashAPI {
    let client = APIClient()
    
    func getPhotos(resultBlock: @escaping ([Photo]?, PhotoAPIError?) -> Void) {
        client.fetchS(resource: UnsplashAPIEndopints.photos) { data, _, errorMessage in
            
            if let error = errorMessage {
                resultBlock(nil, PhotoAPIError.apiFailed(error))
                return
            }
            
            guard let data = data else {
                resultBlock(nil, PhotoAPIError.apiFailed(errorMessage ?? "Unknown error"))
                return
            }
            
            let parser = JSONParser()

            parser.parse(data: data) { (photos: [Photo]?, error: Error?) in
                
                if error != nil {
                    resultBlock(nil, PhotoAPIError.parsingFailed(error?.localizedDescription ?? "Parsing faled"))
                }
                
                guard let photos = photos else {
                    resultBlock(nil, PhotoAPIError.parsingFailed("Photos empty"))
                    return
                }
                resultBlock(photos, nil)
            }
        }
    }
}
