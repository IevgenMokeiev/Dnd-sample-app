//
//  SpellDTOConversionTests.swift
//  SpellBookTests
//
//  Created by Yevhen Mokeiev on 21.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import CoreData
@testable import SpellBook
import XCTest

class SpellDTOConversionTests: XCTestCase {
    func test_spell_population() {
        let coreDataStack = FakeCoreDataStack()
        let context = coreDataStack.persistentContainer.viewContext
        let spell = FakeDataFactory.provideEmptySpell(context: context)
        let spellDTO = FakeDataFactory.provideFakeSpellDTO()
        let expectedSpell = FakeDataFactory.provideFakeSpell(context: context)

        spell.populate(with: spellDTO)
        XCTAssertTrue(spell == expectedSpell)
    }
}
