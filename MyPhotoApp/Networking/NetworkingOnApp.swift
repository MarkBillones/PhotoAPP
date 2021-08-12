//
//  NetworkingOnApp.swift
//  MyPhotoApp
//
//  Created by OPSolutions on 8/11/21.
//

import Foundation

class Networking {
    
    var delegate: DelegateProtocol?
    
    func fetch<Model: Codable>(resource: String, model: Model.Type, completionHandler: @escaping ([Codable]) -> Void) {

        let session = URLSession(configuration: .default)
        let url = URL(string: "\(baseURL)/\(resource)/?client_id=\(APIKey)")

        guard let url = url else {
            return
        }

        let task = session.dataTask(with: url) { data, _, error in
            do {
                let jsonDecoder = JSONDecoder()

                let models = try jsonDecoder.decode([Model].self, from: data!)

                DispatchQueue.main.async { [self] in
                    delegate?.didReceive(models: models)
                    completionHandler(models)
                }

            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
