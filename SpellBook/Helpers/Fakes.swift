//
//  Fakes.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import CoreData
@testable import SpellBook

class FakeRefinementsService: RefinementsService {
    func refineSpells(spells: [SpellDTO], sort: Sort, searchTerm: String) -> [SpellDTO] {
        return spells
    }
}

class FakeDatabaseService: DatabaseService {

    static var spellListHandler: (() -> Result<[SpellDTO], DatabaseServiceError>)?
    static var spellDetailHandler: (() -> Result<SpellDTO, DatabaseServiceError>)?
    static var favoritesHandler: (() -> Result<[SpellDTO], DatabaseServiceError>)?

    func spellListPublisher() -> DatabaseSpellPublisher {
        guard let handler = Self.spellListHandler else {
            fatalError("Handler is unavailable.")
        }
        let result = handler()
        return Result.Publisher(result).eraseToAnyPublisher()
    }

    func spellDetailsPublisher(for path: String) -> DatabaseSpellDetailPublisher {
        guard let handler = Self.spellDetailHandler else {
            fatalError("Handler is unavailable.")
        }
        let result = handler()
        return Result.Publisher(result).eraseToAnyPublisher()
    }

    func favoritesPublisher() -> DatabaseSpellPublisher {
        guard let handler = Self.favoritesHandler else {
            fatalError("Handler is unavailable.")
        }
        let result = handler()
        return Result.Publisher(result).eraseToAnyPublisher()
    }

    func saveSpellList(_ spellDTOs: [SpellDTO]) {
    }

    func saveSpellDetails(_ spellDTO: SpellDTO) {
    }
}

class FakeNetworkService: NetworkService {

    static var spellListHandler: (() -> Result<[SpellDTO], NetworkServiceError>)?

    static var spellDetailHandler: (() -> Result<SpellDTO, NetworkServiceError>)?

    func spellListPublisher() -> NetworkSpellPublisher {
        guard let handler = Self.spellListHandler else {
            fatalError("Handler is unavailable.")
        }
        let result = handler()
        return Result.Publisher(result).eraseToAnyPublisher()
    }

    func spellDetailPublisher(for path: String) -> NetworkSpellDetailPublisher {
        guard let handler = Self.spellDetailHandler else {
            fatalError("Handler is unavailable.")
        }
        let result = handler()
        return Result.Publisher(result).eraseToAnyPublisher()
    }
}

/// A collection of fake services to be used during testing
class FakeTranslationService: TranslationService {

    let testFavorites: Bool

    init(testFavorites: Bool) {
        self.testFavorites = testFavorites
    }

    func convertToDTO(spell: Spell) -> SpellDTO {
        return FakeDataFactory.provideFakeSpellDTO()
    }

    func convertToDTO(spellList: [Spell]) -> [SpellDTO] {
        return testFavorites ? FakeDataFactory.provideFakeFavoritesListDTO() : FakeDataFactory.provideFakeSpellListDTO()
    }
}

class FakeCoreDataStack: CoreDataStack {
    var managedObjectContext: NSManagedObjectContext!
    var persistentContainer: NSPersistentContainer!

    init() {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        persistentContainer = NSPersistentContainer(name: "TestingContainer", managedObjectModel: managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        persistentContainer.loadPersistentStores { (description, error) in
            precondition(description.type == NSInMemoryStoreType)
        }
        managedObjectContext = persistentContainer.viewContext
    }

    func saveContext() {}
}
