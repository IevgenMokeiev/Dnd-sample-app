//
//  ParsingServiceTests.swift
//  Dnd5eAppTests
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import XCTest
@testable import Dnd5eApp

class ParsingServiceTests: XCTestCase {

    func test_parse_from_spellList_data() {
        let sut = ParsingServiceImpl()
        let testData = """
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
        """.data(using: .utf8)
        let result = sut.parseFrom(spellListData: testData!)
        switch result {
        case .success(let spells):
            XCTAssertTrue(spells.count == 2)
            XCTAssertTrue(spells.first?.name == "Acid Arrow")
        case .failure(let error):
            XCTFail("\(error)")
        }
    }

    func test_parse_from_spellDetails_data() {
        let sut = ParsingServiceImpl()
        let testData = """
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
        """.data(using: .utf8)
        let result = sut.parseFrom(spellDetailData: testData!)
        switch result {
        case .success(let spell):
            XCTAssertTrue(spell.name == "Acid Arrow")
            XCTAssertTrue(spell.description == "A shimmering green arrow streaks toward a target within range and bursts in a spray of acid. Make a ranged spell attack against the target. On a hit, the target takes 4d4 acid damage immediately and 2d4 acid damage at the end of its next turn. On a miss, the arrow splashes the target with acid for half as much of the initial damage and no damage at the end of its next turn.")
        case .failure(let error):
            XCTFail("\(error)")
        }
    }
}
