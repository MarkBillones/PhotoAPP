//
//  Protocol.swift
//  MyPhotoApp
//
//  Created by OPSolutions on 8/11/21.
//

import Foundation

protocol API {
    func fetchPhotos()
}

protocol DelegateProtocol {
    func didReceive(models: [Codable])
}
