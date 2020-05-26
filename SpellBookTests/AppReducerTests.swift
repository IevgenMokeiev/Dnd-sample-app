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
        let store = makeSUT()
        let spells = FakeDataFactory.provideFakeSpellListDTO()
        store.send(.showSpellList(spells: spells))
        XCTAssertTrue(store.state.allSpells == spells)
    }

    func test_reduce_to_spell() {
        let store = makeSUT()
        let spell = FakeDataFactory.provideFakeSpellDTO()
        store.send(.showSpell(spell: spell))
        XCTAssertTrue(store.state.selectedSpell == spell)
    }

    func test_reduce_to_favorites() {
        let store = makeSUT()
        let spells = FakeDataFactory.provideFakeFavoritesListDTO()
        store.send(.showFavorites(spells: spells))
        XCTAssertTrue(store.state.favoriteSpells == spells)
    }

    func test_reduce_to_error() {
        let store = makeSUT()
        let error = NetworkClientError.invalidURL as Error
        store.send(.showError(error: error))
        guard let convertedError = store.state.error as? NetworkClientError else { XCTFail("wrong error"); return }
        switch convertedError {
        case .invalidURL:
            return
        default:
            XCTFail("wrong error")
        }
    }

    func test_reduce_toggle_favorite() {
        let store = makeSUT()
        let spell = FakeDataFactory.provideFakeSpellDTO()
        XCTAssertTrue(spell.isFavorite == false)
        store.send(.showSpell(spell: spell))
        store.send(.toggleFavorite)
        XCTAssertTrue(store.state.selectedSpell?.isFavorite == true)
    }

    private func makeSUT() -> AppStore {
        return AppStore(initialState: .init(), reducer: appReducer, environment: FakeServiceContainer(), factory: ViewFactory())
    }
}
