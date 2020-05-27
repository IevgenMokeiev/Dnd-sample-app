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
        let fakeData = FakeDataFactory.provideFakeSpellListDTO()
        store.send(.showSpellList(fakeData))
        guard case let .spellList(displayedSpells, allSpells) = store.state.spellListState else { XCTFail("wrong state"); return }
        XCTAssertTrue(displayedSpells == fakeData)
        XCTAssertTrue(allSpells == fakeData)
    }

    func test_reduce_to_spell() {
        let store = makeSUT()
        let fakeData = FakeDataFactory.provideFakeSpellDTO()
        store.send(.showSpell(fakeData))
        guard case let .selectedSpell(spell) = store.state.spellDetailState else { XCTFail("wrong state"); return }
        XCTAssertTrue(spell == fakeData)
    }

    func test_reduce_to_favorites() {
        let store = makeSUT()
        let fakeData = FakeDataFactory.provideFakeFavoritesListDTO()
        store.send(.showFavorites(fakeData))
        XCTAssertTrue(store.state.favoriteSpells == fakeData)
    }

    func test_reduce_to_error() {
        let store = makeSUT()
        let error = NetworkClientError.invalidURL as Error
        store.send(.showSpellListLoadError(error))
        guard case let .error(loadError) = store.state.spellListState else { XCTFail("wrong state"); return }
        guard let convertedError = loadError as? NetworkClientError else { XCTFail("wrong error"); return }
        switch convertedError {
        case .invalidURL:
            return
        default:
            XCTFail("wrong error")
        }
    }

    func test_reduce_toggle_favorite() {
        let store = makeSUT()
        let fakeData = FakeDataFactory.provideFakeSpellDTO()
        XCTAssertTrue(fakeData.isFavorite == false)
        store.send(.showSpell(fakeData))
        store.send(.toggleFavorite)
        guard case let .selectedSpell(spell) = store.state.spellDetailState else { XCTFail("wrong state"); return }
        XCTAssertTrue(spell.isFavorite == true)
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
            guard case let .spellList(displayedSpells, allSpells)  = appState.spellListState else { XCTFail("wrong state"); return }
            XCTAssertTrue(allSpells == fakeData)
            XCTAssertTrue(displayedSpells == fakeData)
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
            guard case let .selectedSpell(spell) = appState.spellDetailState else { XCTFail("wrong state"); return }
            XCTAssertTrue(spell == fakeData)
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
        return AppStore(initialState: .init(spellListState: .initial, spellDetailState: .initial), reducer: appReducer, environment: FakeServiceContainer())
    }
}
