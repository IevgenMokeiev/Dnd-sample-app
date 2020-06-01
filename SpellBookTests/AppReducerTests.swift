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
        store.send(.spellList(.showSpellList(fakeData)))
        guard case let .spellList(displayedSpells, allSpells) = store.state.spellListState else { XCTFail("wrong state"); return }
        XCTAssertTrue(displayedSpells == fakeData)
        XCTAssertTrue(allSpells == fakeData)
    }

    func test_reduce_to_spell() {
        let store = makeSUT()
        let fakeData = FakeDataFactory.provideFakeSpellDTO()
        store.send(.spellDetail(.showSpell(fakeData)))
        guard case let .selectedSpell(spell) = store.state.spellDetailState else { XCTFail("wrong state"); return }
        XCTAssertTrue(spell == fakeData)
    }

    func test_reduce_to_favorites() {
        let store = makeSUT()
        let fakeData = FakeDataFactory.provideFakeFavoritesListDTO()
        store.send(.favorites(.showFavorites(fakeData)))
        guard case let .favorites(spells) = store.state.favoritesState else { XCTFail("wrong state"); return }
        XCTAssertTrue(spells == fakeData)
    }

    func test_reduce_to_spell_list_error() {
        let store = makeSUT()
        let error = NetworkClientError.invalidURL as Error
        store.send(.spellList(.showSpellListLoadError(error)))
        guard case let .error(loadError) = store.state.spellListState else { XCTFail("wrong state"); return }
        guard let convertedError = loadError as? NetworkClientError else { XCTFail("wrong error"); return }
        switch convertedError {
        case .invalidURL:
            return
        default:
            XCTFail("wrong error")
        }
    }

    func test_request_spell_list(){
        let store = makeSUT()
        let completionExpectation = expectation(description: "wait for sink")
        let fakeData = FakeDataFactory.provideFakeSpellListDTO()

        FakeSpellProviderService.spellListHandler = {
            return Result.success(fakeData)
        }

        store.$state
        .dropFirst(1)
        .sink { appState in
            completionExpectation.fulfill()
            guard case let .spellList(displayedSpells, allSpells)  = appState.spellListState else { XCTFail("wrong state"); return }
            XCTAssertTrue(allSpells == fakeData)
            XCTAssertTrue(displayedSpells == fakeData)
        }.store(in: &cancellableSet)

        store.send(.spellList(.requestSpellList))
        waitForExpectations(timeout: 3)
    }

    func test_request_spell(){
        let store = makeSUT()
        let completionExpectation = expectation(description: "wait for sink")
        let fakeData = FakeDataFactory.provideFakeSpellDTO()

        FakeSpellProviderService.spellDetailHandler = {
            return Result.success(fakeData)
        }

        store.$state
        .dropFirst(2)
        .sink { appState in
            completionExpectation.fulfill()
            guard case let .selectedSpell(spell) = appState.spellDetailState else { XCTFail("wrong state"); return }
            XCTAssertTrue(spell == fakeData)
        }.store(in: &cancellableSet)

        store.send(.spellDetail(.requestSpell(path: "/api/spells/fake")))
        waitForExpectations(timeout: 3)
    }

    func test_request_favorites(){
        let store = makeSUT()
        let completionExpectation = expectation(description: "wait for sink")
        let fakeData = FakeDataFactory.provideFakeFavoritesListDTO()

        FakeSpellProviderService.favoritesHandler = {
            return Result.success(fakeData)
        }

        store.$state
        .dropFirst(1)
        .sink { appState in
            completionExpectation.fulfill()
            guard case let .favorites(spells) = appState.favoritesState else { XCTFail("wrong state"); return }
            XCTAssertTrue(spells == fakeData)
        }.store(in: &cancellableSet)

        store.send(.favorites(.requestFavorites))
        waitForExpectations(timeout: 3)
    }

    func test_reduce_toggle_favorite() {
        let store = makeSUT()
        let completionExpectation = expectation(description: "wait for sink")
        let fakeData = FakeDataFactory.provideFakeSpellDTO()

        XCTAssertTrue(fakeData.isFavorite == false)
        store.send(.spellDetail(.showSpell(fakeData)))
        store.send(.toggleFavorite)
        guard case let .selectedSpell(spell) = store.state.spellDetailState else { XCTFail("wrong state"); return }
        XCTAssertTrue(spell.isFavorite == true)

        FakeSpellProviderService.favoritesHandler = {
            return Result.success([fakeData])
        }

        store.$state
        .dropFirst(1)
        .sink { appState in
            completionExpectation.fulfill()
            guard case let .favorites(spells) = appState.favoritesState else { XCTFail("wrong state"); return }
            XCTAssertTrue(spells == [fakeData])
        }.store(in: &cancellableSet)

        waitForExpectations(timeout: 3)
    }

    func test_reduce_add_spell() {
        let store = makeSUT()
        let fakeData = FakeDataFactory.provideFakeSpellDTO()
        let completionExpectation = expectation(description: "wait for sink")

        store.send(.addSpell(fakeData))
        guard case .initial = store.state.spellListState else { XCTFail("wrong state"); return }


        FakeSpellProviderService.spellListHandler = {
            return Result.success([fakeData])
        }

        store.$state
        .dropFirst(1)
        .sink { appState in
            completionExpectation.fulfill()
            guard case let .spellList(displayedSpells, allSpells)  = appState.spellListState else { XCTFail("wrong state"); return }
            XCTAssertTrue(allSpells == [fakeData])
            XCTAssertTrue(displayedSpells == [fakeData])
        }.store(in: &cancellableSet)

        waitForExpectations(timeout: 3)
    }

    private func makeSUT() -> AppStore {
        return AppStore(initialState: .init(spellListState: .initial, spellDetailState: .initial, favoritesState: .initial), reducer: appReducer, environment: FakeServiceContainer())
    }
}
