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
    case fetchError
    case saveError
}

protocol DatabaseService {
    func fetchSpellList() -> Result<[SpellDTO], DatabaseServiceError>
    func fetchSpell(by name: String) -> Result<SpellDTO, DatabaseServiceError>
    @discardableResult
    func saveDownloadedSpellList(_ spells: [SpellDTO]) -> DatabaseServiceError?
    @discardableResult
    func saveDownloadedSpell(_ spell: SpellDTO) -> DatabaseServiceError?
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
            return .failure(.fetchError)
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
            guard !result.isEmpty else { return .failure(.fetchError) }
            guard let matchedSpell = result.first else { return .failure(.fetchError) }

            if matchedSpell.desc != nil {
                return .success(translationService.convertToDTO(spell: matchedSpell))
            } else {
                return .failure(.fetchError)
            }
        } catch let error as NSError {
            print("Could not retrieve. \(error), \(error.userInfo)")
            return .failure(.fetchError)
        }
    }

    @discardableResult
    func saveDownloadedSpellList(_ spells: [SpellDTO]) -> DatabaseServiceError? {
        let managedContext = coreDataStack.persistentContainer.viewContext
        var spells = [Spell]()

        spells.forEach { (spell) in
            let entity = NSEntityDescription.entity(forEntityName: "Spell", in: managedContext)!
            let spellEntity = Spell(entity: entity, insertInto: managedContext)
            spellEntity.name = spell.name
            spellEntity.path = spell.path
            spells.append(spellEntity)
        }
        
        do {
            try managedContext.save()
            return nil
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return .saveError
        }
    }

    @discardableResult
    func saveDownloadedSpell(_ spell: SpellDTO) -> DatabaseServiceError? {
        let managedContext = coreDataStack.persistentContainer.viewContext
        let request: NSFetchRequest<Spell> = Spell.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", spell.name)
        request.predicate = predicate
        request.returnsObjectsAsFaults = false

        do {
            let result = try managedContext.fetch(request)
            guard !result.isEmpty else { return .fetchError }
            guard let matchedSpell = result.first else { return .fetchError }
            translationService.populate(spell: matchedSpell, with: spell)

            do {
                try managedContext.save()
                return nil
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
                return .saveError
            }
        } catch let error as NSError {
            print("Could not retrieve. \(error), \(error.userInfo)")
            return .fetchError
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
