//
//  PersistentController.swift
//  MyPhotoApp
//
//  Created by OPSolutions on 8/13/21.
//

import CoreData

class PersistentController {
    static let shared = PersistentController()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PhotoGallery")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        //this is to print in debug area the location of your data base
        print(container.persistentStoreDescriptions.first?.url as Any)
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func insertPhoto(_ photo: Photo) {
        let context = persistentContainer.viewContext
        
        let userEntityDescription = NSEntityDescription.entity(forEntityName: "UserModel", in: context)
        let userModel = UserModel(entity: userEntityDescription!, insertInto: context)
        userModel.name = photo.user.name
        userModel.profileImage = photo.user.profileImage.medium
        
        let photoEntityDescription = NSEntityDescription.entity(forEntityName: "PhotoModel", in: context)
        let photoModel = PhotoModel(entity: photoEntityDescription!, insertInto: context)
        photoModel.url = photo.urls.regular
        photoModel.desc = photo.description
        
        //set relationship
        photoModel.user = userModel
        userModel.photo = photoModel
        
        saveContext()
    }
    
    func truncate(entityModel: String) {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityModel)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            _ = try persistentContainer.viewContext.execute(deleteRequest)
        } catch {
            fatalError("Failed to execute request: \(error)")
        }
    }
}
//global na sya, pwedeng maaccess
let DB = PersistentController.shared
