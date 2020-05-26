//
//  AppReducerTests.swift
//  SpellBookTests
//
//  Created by Yevhen Mokeiev on 25.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import XCTest
import Combine
@testable import SpellBook

class AppReducerTests: XCTestCase {

    private var cancellableSet: Set<AnyCancellable> = []

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

    func test_request_spell_list(){
        let store = makeSUT()
        let complationExpectation = expectation(description: "wait for sink")
        let fakeData = FakeDataFactory.provideFakeSpellListDTO()

        FakeSpellProviderService.spellListHandler = {
            return Result.success(fakeData)
        }

        store.$state
        .dropFirst(2)
        .sink { appState in
            complationExpectation.fulfill()
            XCTAssertTrue(appState.allSpells == fakeData)
            XCTAssertTrue(appState.displayedSpells == fakeData)
        }.store(in: &cancellableSet)

        store.send(.requestSpellList)
        waitForExpectations(timeout: 3)
    }

    func test_request_spell(){
        let store = makeSUT()
        let complationExpectation = expectation(description: "wait for sink")
        let fakeData = FakeDataFactory.provideFakeSpellDTO()

        FakeSpellProviderService.spellDetailHandler = {
            return Result.success(fakeData)
        }

        store.$state
        .dropFirst(2)
        .sink { appState in
            complationExpectation.fulfill()
            XCTAssertTrue(appState.selectedSpell == fakeData)
        }.store(in: &cancellableSet)

        store.send(.requestSpell(path: "/api/spells/fake"))
        waitForExpectations(timeout: 3)
    }

    func test_request_favorites(){
        let store = makeSUT()
        let complationExpectation = expectation(description: "wait for sink")
        let fakeData = FakeDataFactory.provideFakeFavoritesListDTO()

        FakeSpellProviderService.favoritesHandler = {
            return Result.success(fakeData)
        }

        store.$state
        .dropFirst(2)
        .sink { appState in
            complationExpectation.fulfill()
            XCTAssertTrue(appState.favoriteSpells == fakeData)
        }.store(in: &cancellableSet)

        store.send(.requestFavorites)
        waitForExpectations(timeout: 3)
    }

    private func makeSUT() -> AppStore {
        return AppStore(initialState: .init(), reducer: appReducer, environment: FakeServiceContainer())
    }
}
