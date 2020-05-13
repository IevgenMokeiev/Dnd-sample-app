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

    func test_spell_population() {
        let sut = makeSUT()
        let spell = FakeDataFactory.provideEmptySpell()
        let spellDTO = FakeDataFactory.provideFakeSpellDTO()
        let expectedSpell = FakeDataFactory.provideFakeSpell()
        sut.populate(spell: spell, with: spellDTO)
        XCTAssertEqual(spell.level, expectedSpell.level)
        XCTAssertEqual(spell.desc, expectedSpell.desc)
        XCTAssertEqual(spell.casting_time, expectedSpell.casting_time)
        XCTAssertEqual(spell.concentration, expectedSpell.concentration)
    }

    func test_spell_dto_conversion() {
        let sut = makeSUT()
        let spell = FakeDataFactory.provideFakeSpell()
        let spellDTO = sut.convertToDTO(spell: spell)
        XCTAssertEqual(spellDTO, FakeDataFactory.provideFakeSpellDTO())
    }

    func test_spellList_dto_conversion() {
        let sut = makeSUT()
        let spellList = FakeDataFactory.provideFakeSpellList()
        let spellDTOs = sut.convertToDTO(spellList: spellList)
        XCTAssertEqual(spellDTOs, FakeDataFactory.provideFakeSpellListDTO())
    }

    private func makeSUT() -> TranslationService {
        return TranslationServiceImpl()
    }
}
