//
//  JSONParser.swift
//  MyPhotoApp
//
//  Created by OPSolutions Billones on 8/11/21.
//

import Foundation

enum ParserError: Error {
    case failed(String)
}

struct JSONParser {
    //generics na nagcoconform sa codable, and codable matches any type that conforms to both protocols., we pass variable data
    //escaping closure
    func parse<Model: Codable>(data: Data, completionHandler: @escaping ([Model]?, Error?) -> Void) {
        do {
            let jsonDecoder = JSONDecoder()
            //we used json decoder, para madecode yung Model, pag tapos na
            let models = try jsonDecoder.decode([Model].self, from: data)
            //nirereturn via completionHandler, which is an array of model
            DispatchQueue.main.async {
                completionHandler(models, nil)
            }
        } catch {//pag may error, error yung irereturn via completionhandler
            completionHandler(nil, ParserError.failed(error.localizedDescription))
        }
    }
}
