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
    let user: User
}
//object Url that gets URL with value "regular"
struct Url: Codable {
    var regular: String
}

struct User: Codable {
    let name: String
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case name, profileImage = "profile_image"
    }
}

struct ProfileImage: Codable {
    let medium: String
}

struct APIResponce: Codable {
    let total: Int
    let total_pages: Int
    let results: [Results]
}

struct Results: Codable {
    let id: String
    let urls: URLS
}

struct URLS: Codable {
    let regular: String
}
