//
//  DatabaseService.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 4/19/19.
//  Copyright © 2019 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import CoreData
import UIKit

enum DatabaseServiceError: Error {
    case emptyStack
    case fetchingError
}

protocol DatabaseService {
    func fetchSpellList() -> Result<[SpellDTO], DatabaseServiceError>
    func fetchSpell(by name:String) -> Result<SpellDTO, DatabaseServiceError>
    func saveDownloadedSpellList(_ spells: [SpellDTO])
    func saveDownloadedSpell(_ spell: SpellDTO)
}

class DatabaseServiceImpl: DatabaseService {

    var coreDataStack: CoreDataStack
    var translationService: TranslationService

    init(coreDataStack: CoreDataStack, translationService: TranslationService) {
        self.coreDataStack = coreDataStack
        self.translationService = translationService
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillTerminate(notification:)), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    func fetchSpellList() -> Result<[SpellDTO], DatabaseServiceError> {
        let context = coreDataStack.persistentContainer.viewContext
        let request: NSFetchRequest<Spell> = Spell.fetchRequest()
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            if result.isEmpty {
                return .failure(.emptyStack)
            } else {
                let spellDTOs = translationService.convertToDTO(spellList: result)
                return .success(spellDTOs)
            }
        } catch let error as NSError {
            print("Could not retrieve. \(error), \(error.userInfo)")
            return .failure(.fetchingError)
        }
    }

    func fetchSpell(by name:String) -> Result<SpellDTO, DatabaseServiceError> {
        let managedContext = coreDataStack.persistentContainer.viewContext
        let request: NSFetchRequest<Spell> = Spell.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", name)
        request.predicate = predicate
        request.returnsObjectsAsFaults = false

        do {
            let result = try managedContext.fetch(request)
            guard !result.isEmpty else { return .failure(.fetchingError) }
            guard let matchedSpell = result.first else { return .failure(.fetchingError) }

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
        let managedContext = coreDataStack.persistentContainer.viewContext

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
        let managedContext = coreDataStack.persistentContainer.viewContext
        let request: NSFetchRequest<Spell> = Spell.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", spell.name)
        request.predicate = predicate
        request.returnsObjectsAsFaults = false

        do {
            let result = try managedContext.fetch(request)
            guard !result.isEmpty else { return }
            guard let matchedSpell = result.first else { return }
            translationService.populate(spell: matchedSpell, with: spell)

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

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext:coreDataStack.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)

        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()

    // MARK: - Notifications
    @objc func applicationWillTerminate(notification: Notification) {
        coreDataStack.saveContext()
    }
}
