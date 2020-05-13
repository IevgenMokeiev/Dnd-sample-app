//
//  TranslationServiceTests.swift
//  Dnd5eAppTests
//
//  Created by Yevhen Mokeiev on 12.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import XCTest
import CoreData
@testable import Dnd5eApp

class TranslationServiceTests: XCTestCase {

    var context: NSManagedObjectContext?

    func test_spell_population() {
        let sut = makeSUT()
        guard let context = context else { XCTFail("no context"); return }
        let spell = FakeDataFactory.provideEmptySpell(context: context)
        let spellDTO = FakeDataFactory.provideFakeSpellDTO()
        let expectedSpell = FakeDataFactory.provideFakeSpell(context: context)
        sut.populate(spell: spell, with: spellDTO)
        XCTAssertTrue(spell == expectedSpell)
    }

    func test_spell_dto_conversion() {
        let sut = makeSUT()
        guard let context = context else { XCTFail("no context"); return }
        let spell = FakeDataFactory.provideFakeSpell(context: context)
        let spellDTO = sut.convertToDTO(spell: spell)
        XCTAssertTrue(spellDTO == FakeDataFactory.provideFakeSpellDTO())
    }

    func test_spellList_dto_conversion() {
        let sut = makeSUT()
        guard let context = context else { XCTFail("no context"); return }
        let spellList = FakeDataFactory.provideFakeSpellList(context: context)        
        let spellDTOs = sut.convertToDTO(spellList: spellList)
        XCTAssertTrue(spellDTOs == FakeDataFactory.provideFakeSpellListDTO())
    }

    private func makeSUT() -> TranslationService {
        let coreDataStack = FakeCoreDataStack()
        context = coreDataStack.persistentContainer.viewContext
        return TranslationServiceImpl()
    }
}
