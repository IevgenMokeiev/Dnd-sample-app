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
