//
//  CoreDataStack.swift
//  Dnd5eApp
//
//  Created by Ievgen on 4/19/19.
//  Copyright © 2019 Ievgen. All rights reserved.
//

import Foundation
import CoreData

enum StackError: Error {
    case emptyStack
    case fetchingError
}

class CoreDataStack {

    public static let shared = CoreDataStack()
    
 // MARK: - Public interface
    
    public func fetchSpellList(_ completionHandler: @escaping (_ result: [Spell]?, _ error: StackError?) -> Void) {
        
        // try fetching results from Core Data stack
        let context = self.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Spell")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            if result.isEmpty {
                completionHandler(nil, .emptyStack)
            } else {
                guard let resultArray = result as? [Spell] else { return }
                completionHandler(resultArray, nil)
            }
        } catch let error as NSError {
            print("Could not retrieve. \(error), \(error.userInfo)")
            completionHandler(nil, .fetchingError)
        }
    }
    
    public func convertDownloadedContent(from objectsArray:[[String: Any]]?) -> [Spell]? {
        let managedContext = self.persistentContainer.viewContext
        var spellArray = [Spell]()
        
        guard let array = objectsArray else { return nil }
        
        for entry in array {
            let entity = NSEntityDescription.entity(forEntityName: "Spell", in: managedContext)!
            let spell = Spell(entity: entity, insertInto: managedContext)
            guard let name = entry["name"] as? String else { return nil }
            guard let url = entry["url"] as? String else { return nil }
            spell.name = name
            spell.url = url
            spellArray.append(spell)
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        return spellArray
    }
    
// MARK: - Core Data stack

    private lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "DnDModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

// MARK: - Core Data Saving support

    public func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
