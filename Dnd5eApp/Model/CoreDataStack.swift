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

protocol CoreDataService {
    var numberOfSpells: Int { get }
    func spell(at indexPath:IndexPath) -> Spell?
    func fetchSpellList(_ completionHandler: @escaping (_ result: [SpellDTO]?, _ error: StackError?) -> Void)
    func translateDownloadedContent(from objectsArray:[[String: Any]]?) -> [SpellDTO]?
    func saveDownloadedSpell(spell: SpellDTO?, object: [String: Any]?)
    func saveContext ()
}

class CoreDataStack: CoreDataService {    
    // MARK: - Public interface
    
    public func fetchSpellList(_ completionHandler: @escaping (_ result: [SpellDTO]?, _ error: StackError?) -> Void) {
        
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
                let spellDTOs = resultArray.map { spell in
                    DataTraslator.convertToDTO(spell: spell)
                }
                completionHandler(spellDTOs, nil)
            }
        } catch let error as NSError {
            print("Could not retrieve. \(error), \(error.userInfo)")
            completionHandler(nil, .fetchingError)
        }
    }
    
    public func translateDownloadedContent(from objectsArray:[[String: Any]]?) -> [SpellDTO]? {
        let managedContext = self.persistentContainer.viewContext
        var spellArray = [SpellDTO]()
        
        guard let array = objectsArray else { return nil }
        
        for entry in array {
            let entity = NSEntityDescription.entity(forEntityName: "Spell", in: managedContext)!
            let spell = Spell(entity: entity, insertInto: managedContext)
            guard let name = entry["name"] as? String else { return nil }
            guard let path = entry["url"] as? String else { return nil }
            spell.name = name
            spell.path = path

            let spellDTO = DataTraslator.convertToDTO(spell: spell)
            spellArray.append(spellDTO)
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        return spellArray
    }
    
    public func saveDownloadedSpell(spell: SpellDTO?, object: [String: Any]?) {
        let managedContext = self.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Spell")
        let predicate = NSPredicate { (object, _) -> Bool in
            guard let spellObject = object as? Spell else { return false }
            return spellObject.name == spell?.name
        }
        request.predicate = predicate

        do {
            let result = try managedContext.fetch(request)

            if result.isEmpty {
                return
            } else {
                guard let resultArray = result as? [Spell] else { return }
                guard let resultSpell = resultArray.first else { return }

                guard let spellObject = object else { return }

                guard let descArray = spellObject["desc"] as? [String] else { return }
                guard let desc = descArray.first else { return }
                resultSpell.desc = desc

                guard let level = spellObject["level"] as? Int16 else { return }
                resultSpell.level = level

                guard let castingTime = spellObject["casting_time"] as? String else { return }
                resultSpell.casting_time = castingTime

                guard let concentration = spellObject["concentration"] as? Bool else { return }
                resultSpell.concentration = concentration

                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        } catch let error as NSError {
            print("Could not retrieve. \(error), \(error.userInfo)")
            return
        }
    }
    
    private lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Spell")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "path", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext:self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()

    
    public var numberOfSpells: Int {
        return self.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    public func spell(at indexPath:IndexPath) -> Spell? {
        return self.fetchedResultsController.object(at: indexPath) as? Spell
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
