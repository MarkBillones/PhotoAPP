//
//  APIModels.swift
//  MyPhotoApp
//
//  Created by OPSolutions Billones on 8/11/21.
//

import Foundation

struct Photo: Codable {
    let description: String?
    let urls: Url
}

struct Url: Codable {
    var regular: String
}

