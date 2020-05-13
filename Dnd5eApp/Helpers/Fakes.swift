//
//  Fakes.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import CoreData
@testable import Dnd5eApp

class FakeParsingService: ParsingService {
    func parseFrom(spellListData: Data) -> Result<[SpellDTO], ParsingError> {
        return .success(FakeDataFactory.provideFakeSpellListDTO())
    }

    func parseFrom(spellDetailData: Data) -> Result<SpellDTO, ParsingError> {
        return .success(FakeDataFactory.provideFakeSpellDTO())
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
