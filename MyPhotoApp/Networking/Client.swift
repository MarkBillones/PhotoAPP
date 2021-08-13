//
//  Client.swift
//  MyPhotoApp
//
//  Created by OPSolutions Billones on 8/11/21.
//

import Foundation

let baseURL = "https://api.unsplash.com"

class APIClient {
    func fetchS(resource: String, orderBy: String = "latest", completionHandler: @escaping (Data?, URLResponse?, String?) -> Void) {
        let session = URLSession(configuration: .default)
        let url = URL(string: "\(baseURL)/\(resource)?client_id=\(APIKey)&order_by\(orderBy)")
        
        guard let url = url else {
            completionHandler(nil, nil, "Url is nil")
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            completionHandler(data, response, error?.localizedDescription )
        }
        
        task.resume()
    }
}
