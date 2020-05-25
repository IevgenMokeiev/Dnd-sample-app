//
//  AppReducerTests.swift
//  SpellBookTests
//
//  Created by Yevhen Mokeiev on 25.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import XCTest
@testable import SpellBook

class AppReducerTests: XCTestCase {

    func test_reduce_to_spell_list() {
        let store = AppStore(initialState: .init(), reducer: appReducer, environment: FakeServiceContainer(), factory: ViewFactory())

        let spells = FakeDataFactory.provideFakeSpellListDTO()

        store.send(.showSpellList(spells: spells))

        XCTAssertTrue(store.state.allSpells == spells)
    }
}
