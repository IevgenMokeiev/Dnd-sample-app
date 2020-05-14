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

enum DatabaseServiceError: Error {
    case emptyStack
    case fetchError
    case saveError
}

protocol DatabaseService {
    func fetchSpellList() -> AnyPublisher<[SpellDTO], DatabaseServiceError>
    func fetchSpell(by name: String) -> AnyPublisher<SpellDTO, DatabaseServiceError>
    func saveDownloadedSpellList(_ spellDTOs: [SpellDTO]) -> AnyPublisher<[SpellDTO], DatabaseServiceError>
    func saveDownloadedSpell(_ spellDTO: SpellDTO) -> AnyPublisher<SpellDTO, DatabaseServiceError>
}

class DatabaseServiceImpl: DatabaseService {
    
    private var coreDataStack: CoreDataStack
    private var translationService: TranslationService
    private var bag = Set<AnyCancellable>()

    init(coreDataStack: CoreDataStack, translationService: TranslationService) {
        self.coreDataStack = coreDataStack
        self.translationService = translationService
        NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)
            .sink { _ in coreDataStack.saveContext() }
            .store(in: &bag)
    }
    
    func fetchSpellList() -> AnyPublisher<[SpellDTO], DatabaseServiceError> {
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
            return Fail(error: .fetchError).eraseToAnyPublisher()
        }
    }
    
    func fetchSpell(by name: String) -> AnyPublisher<SpellDTO, DatabaseServiceError> {
        let managedContext = coreDataStack.persistentContainer.viewContext
        let request: NSFetchRequest<Spell> = Spell.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", name)
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try managedContext.fetch(request)
            guard !result.isEmpty else { return Fail(error: .fetchError).eraseToAnyPublisher() }
            guard let matchedSpell = result.first else { return Fail(error: .fetchError).eraseToAnyPublisher() }
            
            if matchedSpell.desc != nil {
                return Result.Publisher(translationService.convertToDTO(spell: matchedSpell)).eraseToAnyPublisher()
            } else {
                return Fail(error: .fetchError).eraseToAnyPublisher()
            }
        } catch let error as NSError {
            print("Could not retrieve. \(error), \(error.userInfo)")
            return Fail(error: .fetchError).eraseToAnyPublisher()
        }
    }

    func saveDownloadedSpellList(_ spellDTOs: [SpellDTO]) -> AnyPublisher<[SpellDTO], DatabaseServiceError> {
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
            return Fail(error: .saveError).eraseToAnyPublisher()
        }
    }

    func saveDownloadedSpell(_ spellDTO: SpellDTO) -> AnyPublisher<SpellDTO, DatabaseServiceError> {
        let managedContext = coreDataStack.persistentContainer.viewContext
        let request: NSFetchRequest<Spell> = Spell.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", spellDTO.name)
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try managedContext.fetch(request)
            guard !result.isEmpty else { return Fail(error: .fetchError).eraseToAnyPublisher() }
            guard let matchedSpell = result.first else { return Fail(error: .fetchError).eraseToAnyPublisher() }
            translationService.populate(spell: matchedSpell, with: spellDTO)
            
            do {
                try managedContext.save()
                return Result.Publisher(spellDTO).eraseToAnyPublisher()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
                return Fail(error: .saveError).eraseToAnyPublisher()
            }
        } catch let error as NSError {
            print("Could not retrieve. \(error), \(error.userInfo)")
            return Fail(error: .fetchError).eraseToAnyPublisher()
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
