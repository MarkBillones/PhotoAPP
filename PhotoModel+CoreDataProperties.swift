//
//  PhotoModel+CoreDataProperties.swift
//  MyPhotoApp
//
//  Created by OPSolutions on 8/13/21.
//
//

import Foundation
import CoreData


extension PhotoModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoModel> {
        return NSFetchRequest<PhotoModel>(entityName: "PhotoModel")
    }

    @NSManaged public var desc: String?
    @NSManaged public var url: String?
    @NSManaged public var user: UserModel?

}

extension PhotoModel : Identifiable {

}
