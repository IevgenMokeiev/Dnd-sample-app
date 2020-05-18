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
import Combine

typealias DatabaseSpellListPublisher = AnyPublisher<[SpellDTO], DatabaseServiceError>
typealias DatabaseSpellDetailPublisher = AnyPublisher<SpellDTO, DatabaseServiceError>

enum DatabaseServiceError: Error {
    case emptyStack
    case noMatchedEntity
    case entityNotPopulated
    case fetchFailed(Error)
    case saveFailed(Error)
}

protocol DatabaseService {
    func spellListPublisher() -> DatabaseSpellListPublisher
    func spellDetailsPublisher(for name: String) -> DatabaseSpellDetailPublisher
    func saveSpellListPublisher(for spellDTOs: [SpellDTO]) -> DatabaseSpellListPublisher
    func saveSpellDetailsPublisher(for spellDTO: SpellDTO) -> DatabaseSpellDetailPublisher
}

class DatabaseServiceImpl: DatabaseService {
    
    private var coreDataStack: CoreDataStack
    private var translationService: TranslationService
    private var cancellableSet: Set<AnyCancellable> = []

    init(coreDataStack: CoreDataStack, translationService: TranslationService) {
        self.coreDataStack = coreDataStack
        self.translationService = translationService
        NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)
            .sink { _ in coreDataStack.saveContext() }
            .store(in: &cancellableSet)
    }
    
    func spellListPublisher() -> DatabaseSpellListPublisher {
        let context = coreDataStack.persistentContainer.viewContext
        let request: NSFetchRequest<Spell> = Spell.fetchRequest()
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            if result.isEmpty {
                return Fail(error: .emptyStack).eraseToAnyPublisher()
            } else {
                let spellDTOs = translationService.convertToDTO(spellList: result)
                return Result.Publisher(spellDTOs).eraseToAnyPublisher()
            }
        } catch let error as NSError {
            print("Could not retrieve. \(error), \(error.userInfo)")
            return Fail(error: .fetchFailed(error)).eraseToAnyPublisher()
        }
    }
    
    func spellDetailsPublisher(for name: String) -> DatabaseSpellDetailPublisher {
        let managedContext = coreDataStack.persistentContainer.viewContext
        let request: NSFetchRequest<Spell> = Spell.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", name)
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try managedContext.fetch(request)
            guard !result.isEmpty else { return Fail(error: .noMatchedEntity).eraseToAnyPublisher() }
            guard let matchedSpell = result.first else { return Fail(error: .noMatchedEntity).eraseToAnyPublisher() }
            
            if matchedSpell.desc != nil {
                return Result.Publisher(translationService.convertToDTO(spell: matchedSpell)).eraseToAnyPublisher()
            } else {
                return Fail(error: .entityNotPopulated).eraseToAnyPublisher()
            }
        } catch let error as NSError {
            print("Could not retrieve. \(error), \(error.userInfo)")
            return Fail(error: .fetchFailed(error)).eraseToAnyPublisher()
        }
    }

    func saveSpellListPublisher(for spellDTOs: [SpellDTO]) -> DatabaseSpellListPublisher {
        let managedContext = coreDataStack.persistentContainer.viewContext
        spellDTOs.forEach { (spell) in
            let entity = NSEntityDescription.entity(forEntityName: "Spell", in: managedContext)!
            let spellEntity = Spell(entity: entity, insertInto: managedContext)
            spellEntity.name = spell.name
            spellEntity.path = spell.path
        }
        
        do {
            try managedContext.save()
            return Result.Publisher(spellDTOs).eraseToAnyPublisher()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return Fail(error: .saveFailed(error)).eraseToAnyPublisher()
        }
    }

    func saveSpellDetailsPublisher(for spellDTO: SpellDTO) -> DatabaseSpellDetailPublisher {
        let managedContext = coreDataStack.persistentContainer.viewContext
        let request: NSFetchRequest<Spell> = Spell.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", spellDTO.name)
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try managedContext.fetch(request)
            guard !result.isEmpty else { return Fail(error: .noMatchedEntity).eraseToAnyPublisher() }
            guard let matchedSpell = result.first else { return Fail(error: .noMatchedEntity).eraseToAnyPublisher() }
            translationService.populate(spell: matchedSpell, with: spellDTO)
            
            do {
                try managedContext.save()
                return Result.Publisher(spellDTO).eraseToAnyPublisher()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
                return Fail(error: .saveFailed(error)).eraseToAnyPublisher()
            }
        } catch let error as NSError {
            print("Could not retrieve. \(error), \(error.userInfo)")
            return Fail(error: .fetchFailed(error)).eraseToAnyPublisher()
        }
    }
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Spell> = {
        let fetchRequest: NSFetchRequest<Spell> = Spell.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext:coreDataStack.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
}
