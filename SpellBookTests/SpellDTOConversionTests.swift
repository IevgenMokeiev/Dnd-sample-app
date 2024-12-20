//
//  SpellDTOConversionTests.swift
//  SpellBookTests
//
//  Created by Yevhen Mokeiev on 21.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import CoreData
@testable import SpellBook
import Testing

@Suite
final class SpellDTOConversionTests {
    
    @Test
    func whenPopulateSpell_thenHasExpectedData() {
        let coreDataStack = StubCoreDataStack()
        let context = coreDataStack.persistentContainer.viewContext
        let spell = FakeDataFactory.provideEmptySpell(context: context)
        let spellDTO = FakeDataFactory.provideFakeSpellDTO()
        let expectedSpell = FakeDataFactory.provideFakeSpell(context: context)

        spell.populate(with: spellDTO)
        #expect(spell == expectedSpell)
    }
}
