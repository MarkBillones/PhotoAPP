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
    
    func insert(_ photo: Photo) {
        let photoEntity = NSEntityDescription.entity(forEntityName: "PhotoModel", in: self.persistentContainer.viewContext)
        let model = PhotoModel(entity: photoEntity!, insertInto: self.persistentContainer.viewContext)
        model.url = photo.urls.regular
    }
}
