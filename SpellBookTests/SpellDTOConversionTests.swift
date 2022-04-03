//
//  SpellDTOConversionTests.swift
//  SpellBookTests
//
//  Created by Yevhen Mokeiev on 21.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import XCTest
import CoreData
@testable import SpellBook

class SpellDTOConversionTests: XCTestCase {

  func test_spell_population() {
    let coreDataStack = FakeCoreDataStack()
    let context = coreDataStack.persistentContainer.viewContext
    let spell = FakeDataFactory.emptySpell(context: context)
    let spellDTO = FakeDataFactory.spellDTO
    let expectedSpell = FakeDataFactory.spell(context: context)

    spell.populate(with: spellDTO)
    XCTAssertTrue(spell == expectedSpell)
  }
}
