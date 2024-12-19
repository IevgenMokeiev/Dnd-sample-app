//
//  TranslationServiceTesting.swift
//  SpellBookTests
//
//  Created by Eugene Mokeiev on 19.12.2024.
//  Copyright © 2024 Ievgen. All rights reserved.
//

import CoreData
@testable import SpellBook
import Testing

@Suite
struct TranslationServiceTests {
    
    var context: NSManagedObjectContext
    var sut: TranslationServiceImpl
    
    init() async throws {
        let coreDataStack = CoreDataStackMock()
        context = coreDataStack.persistentContainer.viewContext
        sut = TranslationServiceImpl()
      }

    @Test
    mutating func whenUsingSpellConversion_thenProducesExpectedResult() throws {
        let context = try #require(context)
        let spell = FakeDataFactory.provideFakeSpell(context: context)
        let spellDTO = sut.convertToDTO(spell: spell)
        #expect(spellDTO == FakeDataFactory.provideFakeSpellDTO())
    }
    
    @Test
    func whenUsingSpellListConversion_thenProducesExpectedResult() throws {
        let context = try #require(context)
        let spellList = FakeDataFactory.provideFakeSpellList(context: context)
        let spellDTOs = sut.convertToDTO(spellList: spellList)
        #expect(spellDTOs == FakeDataFactory.provideFakeSpellListDTO())
    }
}
