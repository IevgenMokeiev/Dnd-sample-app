//
//  FakeDataFactory.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import CoreData
import Foundation
@testable import SpellBook
import SwiftData

class FakeDataFactory {
    static func provideFakeSpellDTO() -> SpellDTO {
        return SpellDTO(name: "fake", path: "/api/spells/fake", level: 1, castingTime: "fake time", isConcentration: true, classes: "fake class", description: "fake desc", isFavorite: false)
    }
    
    static func provideEmptySpellListDTO() -> [SpellDTO] {
        return [
            SpellDTO(name: "fake1", path: "/api/spells/fake1", level: nil, castingTime: nil, isConcentration: nil, classes: nil, description: nil, isFavorite: false),
            SpellDTO(name: "fake2", path: "/api/spells/fake2", level: nil, castingTime: nil, isConcentration: nil, classes: nil, description: nil, isFavorite: false),
        ]
    }
    
    static func provideFakeSpellListDTO() -> [SpellDTO] {
        return [
            SpellDTO(name: "fake1", path: "/api/spells/fake1", level: 1, castingTime: "fake time 1", isConcentration: true, classes: "fake class 1", description: "fake desc 1", isFavorite: false),
            SpellDTO(name: "fake2", path: "/api/spells/fake2", level: 0, castingTime: "fake time 2", isConcentration: false, classes: "fake class 2", description: "fake desc 2", isFavorite: false),
        ]
    }
    
    static func provideFakeFavoritesListDTO() -> [SpellDTO] {
        return [
            SpellDTO(name: "fake2", path: "/api/spells/fake2", level: 0, castingTime: "fake time 2", isConcentration: false, classes: "fake class 2", description: "fake desc 2", isFavorite: true),
        ]
    }
    
    static func provideEmptySpell() -> Spell {
        Spell(castingTime: "", classes: "", components: "", isConcentration: false, spellDescription: "", duration: "", higherLevel: "", isFavorite: false, level: 0, material: "", name: "", page: "", path: "", range: "", ritual: "", school: "", subclasses: "")
    }
    
    static func provideFakeSpell() -> Spell {
        return Spell(with: provideFakeSpellDTO())
    }

    static func provideFakeSpellList() -> [Spell] {
        provideFakeSpellListDTO().map { Spell(with: $0)}
    }

    static func provideFakeFavoritesList() -> [Spell] {
        provideFakeFavoritesListDTO().map { Spell(with: $0)}
    }
    
    static func provideFakeSpellDetailsRawData() -> Data {
        return """
        {
            "_id": "5eb89d6c0b1bb138c5676654",
            "index": "acid-arrow",
            "name": "fake",
            "desc": [
                "fake desc"
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
            "concentration": true,
            "casting_time": "fake time",
            "level": 1,
            "school": {
                "name": "Evocation",
                "url": "/api/magic-schools/evocation"
            },
            "classes": [
                {
                    "name": "fake class",
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
            "url": "/api/spells/fake"
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
                    "name": "fake1",
                    "url": "/api/spells/fake1"
                },
                {
                    "index": "acid-splash",
                    "name": "fake2",
                    "url": "/api/spells/fake2"
                }
            ]
        }
        """.data(using: .utf8)!
    }
}
