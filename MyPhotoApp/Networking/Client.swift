//
//  Client.swift
//  MyPhotoApp
//
//  Created by OPSolutions on 8/11/21.
//

import Foundation

class Client: DelegateProtocol {
    func didReceive(models: [Codable]) {
        debugPrint(models)
    }
}
