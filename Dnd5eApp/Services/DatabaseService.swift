//
//  DatabaseService.swift
//  Dnd5eApp
//
//  Created by Ievgen on 4/19/19.
//  Copyright © 2019 Ievgen. All rights reserved.
//

import Foundation
import CoreData

enum DatabaseServiceError: Error {
    case emptyStack
    case fetchingError
}

protocol DatabaseService {
    func fetchSpellList() -> Result<[SpellDTO], DatabaseServiceError>
    func fetchSpell(by name:String) -> Result<SpellDTO, DatabaseServiceError>
    func saveDownloadedSpellList(_ spells: [SpellDTO])
    func saveDownloadedSpell(_ spell: SpellDTO)
    func saveContext()
}

class DatabaseServiceImpl: DatabaseService {
    // MARK: - Public interface

    var translationService: TranslationService

    init(translationService: TranslationService) {
        self.translationService = translationService
    }
    
    func fetchSpellList() -> Result<[SpellDTO], DatabaseServiceError> {
        // try fetching results from Core Data stack
        let context = self.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Spell")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            if result.isEmpty {
                return .failure(.emptyStack)
            } else {
                guard let resultArray = result as? [Spell] else { return .failure(.fetchingError) }
                let spellDTOs = resultArray.map { spell in
                    translationService.convertToDTO(spell: spell)
                }
                return .success(spellDTOs)
            }
        } catch let error as NSError {
            print("Could not retrieve. \(error), \(error.userInfo)")
            return .failure(.fetchingError)
        }
    }

    func fetchSpell(by name:String) -> Result<SpellDTO, DatabaseServiceError> {
        let managedContext = self.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Spell")
        let predicate = NSPredicate(format: "name == %@", name)
        request.predicate = predicate
        request.returnsObjectsAsFaults = false

        do {
            let result = try managedContext.fetch(request)
            guard !result.isEmpty else { return .failure(.fetchingError) }
            guard let matchedArray = result as? [Spell] else { return .failure(.fetchingError) }
            guard let matchedSpell = matchedArray.first else { return .failure(.fetchingError) }

            if matchedSpell.desc != nil {
                return .success(translationService.convertToDTO(spell: matchedSpell))
            } else {
                return .failure(.fetchingError)
            }
        } catch let error as NSError {
            print("Could not retrieve. \(error), \(error.userInfo)")
            return .failure(.fetchingError)
        }
    }
    
    func saveDownloadedSpellList(_ spells: [SpellDTO]) {
        let managedContext = self.persistentContainer.viewContext

        spells.forEach { (spell) in
            let entity = NSEntityDescription.entity(forEntityName: "Spell", in: managedContext)!
            let spellEntity = Spell(entity: entity, insertInto: managedContext)
            spellEntity.name = spell.name
            spellEntity.path = spell.path
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func saveDownloadedSpell(_ spell: SpellDTO) {
        let managedContext = self.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Spell")
        let predicate = NSPredicate(format: "name == %@", spell.name)
        request.predicate = predicate
        request.returnsObjectsAsFaults = false

        do {
            let result = try managedContext.fetch(request)
            guard !result.isEmpty else { return }
            guard let matchedArray = result as? [Spell] else { return }
            guard let matchedSpell = matchedArray.first else { return }

            translationService.populateSpellWith(dto: spell, spell: matchedSpell)

            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            print("Could not retrieve. \(error), \(error.userInfo)")
        }
    }

    private lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Spell")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "path", ascending: true)]

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext:self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)

        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
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
