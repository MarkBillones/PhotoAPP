//
//  NetworkingOnApp.swift
//  MyPhotoApp
//
//  Created by OPSolutions on 8/11/21.
//

import Foundation

let baseURL = "https://api.unsplash.com"

class Networking: API {
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
    
    func fetchPhotos() {
        let session = URLSession(configuration: .default)
        let url = URL(string: "\(baseURL)/photos")
        
        guard let url = url else {
            return
        }
        
        let task = session.dataTask(with: url) {    data, _, error in
            do {
                let jsonDecoder = JSONDecoder()
                
                let photos = try jsonDecoder.decode([Photo].self, from: data!)
                
                for photos in photos {
                    print("Description: \(String(describing: photos.description))")
                }
            }catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
//    func fetchTodos() {
//        let session = URLSession(configuration: .default)
//        let url = URL(string: "\(baseURL)/todos")
//
//        guard let url = url else {
//            return
//        }
//
//        let task = session.dataTask(with: url) { data, _, error in
//            do {
//                let jsonDecoder = JSONDecoder()
//                let todos = try jsonDecoder.decode([Todo].self, from: data!)
//                for todo in todos {
//                    print("Id \(todo.id) \n title \(todo.title)")
//                }
//            }catch {
//                print(error)
//            }
//        }
//
//        task.resume()
//    }
}
