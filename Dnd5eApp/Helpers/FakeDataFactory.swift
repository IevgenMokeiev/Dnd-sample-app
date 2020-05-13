//
//  FakeDataFactory.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import CoreData
@testable import Dnd5eApp

class FakeDataFactory {

    static func provideFakeSpellDTO() -> SpellDTO {
        return SpellDTO(name: "fake", path: "/fake", level: 1, description: "fake desc", castingTime: "fake time", concentration: true)
    }

    static func provideFakeSpellListDTO() -> [SpellDTO] {
        return [
            SpellDTO(name: "fake1", path: "/fake1", level: 1, description: "fake desc 1", castingTime: "fake time 1", concentration: true),
            SpellDTO(name: "fake2", path: "/fake2", level: 0, description: "fake desc 2", castingTime: "fake time 2", concentration: false)
        ]
    }

    static func provideEmptySpell() -> Spell {
        let coreDataStack = FakeCoreDataStack()
        let context = coreDataStack.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Spell", in: context)!
        let spell = Spell(entity: entity, insertInto: context)
        
        return spell
    }

    static func provideFakeSpell() -> Spell {
        let coreDataStack = FakeCoreDataStack()
        let context = coreDataStack.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Spell", in: context)!
        let spell = Spell(entity: entity, insertInto: context)
        spell.name = "fake"
        spell.path = "/fake"
        spell.level = 1
        spell.desc = "fake desc"
        spell.casting_time = "fake time"
        spell.concentration = true
        try? context.save()

        return spell
    }

    static func provideFakeSpellList() -> [Spell] {
        let coreDataStack = FakeCoreDataStack()
        let context = coreDataStack.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Spell", in: context)!
        let spell1 = Spell(entity: entity, insertInto: context)
        spell1.name = "fake1"
        spell1.path = "/fake1"
        spell1.level = 1
        spell1.desc = "fake desc 1"
        spell1.casting_time = "fake time 1"
        spell1.concentration = true
        let spell2 = Spell(entity: entity, insertInto: context)
        spell2.name = "fake2"
        spell2.path = "/fake2"
        spell2.level = 0
        spell2.desc = "fake desc 2"
        spell2.casting_time = "fake time 2"
        spell2.concentration = false
        try? context.save()

        return [spell1, spell2]
    }

    static func provideFakeSpellDetailsRawData() -> Data {
        return """
        {
            "_id": "5eb89d6c0b1bb138c5676654",
            "index": "acid-arrow",
            "name": "Acid Arrow",
            "desc": [
                "A shimmering green arrow streaks toward a target within range and bursts in a spray of acid. Make a ranged spell attack against the target. On a hit, the target takes 4d4 acid damage immediately and 2d4 acid damage at the end of its next turn. On a miss, the arrow splashes the target with acid for half as much of the initial damage and no damage at the end of its next turn."
            ],
            "higher_level": [
                "When you cast this spell using a spell slot of 3rd level or higher, the damage (both initial and later) increases by 1d4 for each slot level above 2nd."
            ],
            "range": "90 feet",
            "components": [
                "V",
                "S",
                "M"
            ],
            "material": "Powdered rhubarb leaf and an adder's stomach.",
            "ritual": false,
            "duration": "Instantaneous",
            "concentration": false,
            "casting_time": "1 action",
            "level": 2,
            "school": {
                "name": "Evocation",
                "url": "/api/magic-schools/evocation"
            },
            "classes": [
                {
                    "name": "Wizard",
                    "url": "/api/classes/wizard"
                }
            ],
            "subclasses": [
                {
                    "name": "Lore",
                    "url": "/api/subclasses/lore"
                },
                {
                    "name": "Land",
                    "url": "/api/subclasses/land"
                }
            ],
            "url": "/api/spells/acid-arrow"
        }
        """.data(using: .utf8)!
    }

    static func provideFakeSpellListRawData() -> Data {
        return """
        {
            "count": 2,
            "results": [
                {
                    "index": "acid-arrow",
                    "name": "Acid Arrow",
                    "url": "/api/spells/acid-arrow"
                },
                {
                    "index": "acid-splash",
                    "name": "Acid Splash",
                    "url": "/api/spells/acid-splash"
                }
            ]
        }
        """.data(using: .utf8)!
    }
}
