//
//  TranslationServiceTests.swift
//  SpellBookTests
//
//  Created by Eugene Mokeiev on 19.12.2024.
//  Copyright © 2024 Ievgen. All rights reserved.
//

import CoreData
@testable import SpellBook
import Testing

@Suite
final class TranslationServiceTests {
    
    private var context: NSManagedObjectContext!
    private var sut: TranslationServiceImpl!
    
    init() {
        let coreDataStack = StubCoreDataStack()
        context = coreDataStack.persistentContainer.viewContext
        sut = TranslationServiceImpl()
    }
    
    deinit {
        context = nil
        sut = nil
    }

    @Test
    func whenUsingSpellConversion_thenReturnsExpectedResult() throws {
        let context = try #require(context)
        let sut = try #require(sut)
        let spell = FakeDataFactory.provideFakeSpell(context: context)
        let spellDTO = sut.convertToDTO(spell: spell)
        #expect(spellDTO == FakeDataFactory.provideFakeSpellDTO())
    }
    
    @Test
    func whenUsingSpellListConversion_thenReturnsExpectedResult() throws {
        let context = try #require(context)
        let sut = try #require(sut)
        let spellList = FakeDataFactory.provideFakeSpellList(context: context)
        let spellDTOs = sut.convertToDTO(spellList: spellList)
        #expect(spellDTOs == FakeDataFactory.provideFakeSpellListDTO())
    }
}
