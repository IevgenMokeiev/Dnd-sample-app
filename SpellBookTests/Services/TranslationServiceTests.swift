//
//  TranslationServiceTests.swift
//  SpellBookTests
//
//  Created by Yevhen Mokeiev on 12.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import XCTest
import CoreData
@testable import SpellBook

class TranslationServiceTests: XCTestCase {
    
    var context: NSManagedObjectContext?
    
    func test_spell_dto_conversion() {
        let sut = makeSUT()
        guard let context = context else { XCTFail("no context"); return }
        let spell = FakeDataFactory.spell(context: context)
        let spellDTO = sut.convertToDTO(spell: spell)
        XCTAssertEqual(spellDTO, FakeDataFactory.spellDTO)
    }
    
    func test_spellList_dto_conversion() {
        let sut = makeSUT()
        guard let context = context else { XCTFail("no context"); return }
        let spellList = FakeDataFactory.spellList(context: context)
        let spellDTOs = sut.convertToDTO(spellList: spellList)
        XCTAssertTrue(spellDTOs == FakeDataFactory.spellListDTO)
    }
    
    private func makeSUT() -> TranslationService {
        let coreDataStack = FakeCoreDataStack()
        context = coreDataStack.persistentContainer.viewContext
        return TranslationServiceImpl()
    }
}

