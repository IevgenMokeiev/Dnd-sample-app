//
//  DatabaseServiceTests.swift
//  Dnd5eAppTests
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import XCTest
import CoreData
@testable import Dnd5eApp

class DatabaseServiceTests: XCTestCase {

    var context: NSManagedObjectContext?

    func test_spellList_fetch() {
        let sut = makeSUT()
        guard let context = context else { XCTFail("no context"); return }
        _ = FakeDataFactory.provideFakeSpellList(context: context)
        let result = sut.fetchSpellList()

        switch result {
        case .success(let spellDTOs):
            XCTAssertEqual(spellDTOs, FakeDataFactory.provideFakeSpellListDTO())
        case .failure(let error):
            XCTFail("\(error)")
        }
    }

    func test_spell_fetch() {
        let sut = makeSUT()
        guard let context = context else { XCTFail("no context"); return }
        let spell = FakeDataFactory.provideFakeSpell(context: context)
        let result = sut.fetchSpell(by: spell.name!)

        switch result {
        case .success(let spellDTO):
            XCTAssertEqual(spellDTO, FakeDataFactory.provideFakeSpellDTO())
        case .failure(let error):
            XCTFail("\(error)")
        }
    }

    func test_save_spellList() {
        let sut = makeSUT()
        let result = sut.saveDownloadedSpellList(FakeDataFactory.provideFakeSpellListDTO())
        XCTAssertNil(result)
    }

    func test_save_spell() {
        let sut = makeSUT()
        guard let context = context else { XCTFail("no context"); return }
        _ = FakeDataFactory.provideFakeSpell(context: context)
        XCTAssertNil(sut.saveDownloadedSpell(FakeDataFactory.provideFakeSpellDTO()))
    }

    private func makeSUT() -> DatabaseService {
        let fakeStack = FakeCoreDataStack()
        context = fakeStack.persistentContainer.viewContext
        return DatabaseServiceImpl(coreDataStack: fakeStack, translationService: FakeTranslationService())
    }
}
