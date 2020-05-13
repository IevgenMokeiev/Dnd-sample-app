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
        let sut = makeSUT()
        let testData = FakeDataFactory.provideFakeSpellListRawData()
        let result = sut.parseFrom(spellListData: testData)
        switch result {
        case .success(let spells):
            XCTAssertEqual(spells.count, 2)
            XCTAssertEqual(spells.first?.name, "Acid Arrow")
        case .failure(let error):
            XCTFail("\(error)")
        }
    }

    func test_parse_from_spellDetails_data() {
        let sut = makeSUT()
        let testData = FakeDataFactory.provideFakeSpellDetailsRawData()
        let result = sut.parseFrom(spellDetailData: testData)
        switch result {
        case .success(let spell):
            XCTAssertEqual(spell.name, "Acid Arrow")
            XCTAssertEqual(spell.description, "A shimmering green arrow streaks toward a target within range and bursts in a spray of acid. Make a ranged spell attack against the target. On a hit, the target takes 4d4 acid damage immediately and 2d4 acid damage at the end of its next turn. On a miss, the arrow splashes the target with acid for half as much of the initial damage and no damage at the end of its next turn.")
        case .failure(let error):
            XCTFail("\(error)")
        }
    }

    private func makeSUT() -> ParsingService {
        return ParsingServiceImpl()
    }
}
