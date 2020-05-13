//
//  TranslationServiceTests.swift
//  Dnd5eAppTests
//
//  Created by Yevhen Mokeiev on 12.05.2020.
//  Copyright © 2020 Ievgen. All rights reserved.
//

import XCTest
import CoreData
@testable import Dnd5eApp

class TranslationServiceTests: XCTestCase {
    // TODO: - check and reenable
    func test_spell_population() throws {
        let translationService = TranslationServiceImpl()
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let entity = NSEntityDescription.entity(forEntityName: "Spell", in: context)!
        let spell = Spell(entity: entity, insertInto: context)
        spell.name = "test"
        spell.path = "/path"
        let spellDTO = SpellDTO(name: "test", path: "/path", level: 1, description: "desc", castingTime: "1 action", concentration: true)
        translationService.populate(spell: spell, with: spellDTO)
        XCTAssertEqual(spell.level, 1)
        XCTAssertEqual(spell.desc, "desc")
        XCTAssertEqual(spell.casting_time, "1 action")
        XCTAssertEqual(spell.concentration, true)
    }
}
