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
        let spell = FakeDataFactory.provideEmptySpell()
        let spellDTO = FakeDataFactory.provideFakeSpellDTO()
        let expectedSpell = FakeDataFactory.provideFakeSpell()

        spell.populate(with: spellDTO)
        #expect(spell == expectedSpell)
    }
}
