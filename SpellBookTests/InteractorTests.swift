//
//  InteractorTests.swift
//  SpellBookTests
//
//  Created by Yevhen Mokeiev on 22.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import XCTest
import Combine
@testable import SpellBook

class InteractorTests: XCTestCase {

    private var cancellableSet: Set<AnyCancellable> = []

    func test_spellList_fetch_no_local_data() {
        let sut = makeSUT()
        let interactorExpectation = expectation(description: "wait for interactor")

        let fakeData = FakeDataFactory.provideFakeSpellListDTO()

        FakeNetworkService.spellListHandler = {
            return Result.success(fakeData)
        }

        FakeDatabaseService.spellListHandler = {
            return Result.failure(DatabaseClientError.noData)
        }

        sut.spellListPublisher()
        .sink(receiveCompletion: { completion in
            interactorExpectation.fulfill()
            switch completion {
            case .finished:
                break
            case .failure(let error):
                XCTFail("\(error)")
            }
        }) { spellDTOs in
            XCTAssertTrue(spellDTOs == fakeData)
        }
        .store(in: &cancellableSet)

        waitForExpectations(timeout: 5)
    }

    func test_spellList_fetch_from_local_data() {
        let sut = makeSUT()
        let interactorExpectation = expectation(description: "wait for interactor")

        let fakeData = FakeDataFactory.provideFakeSpellListDTO()

        FakeNetworkService.spellListHandler = {
            XCTFail("Should't call network in thic case")
            return Result.success(fakeData)
        }

        FakeDatabaseService.spellListHandler = {
            return Result.success(fakeData)
        }

        sut.spellListPublisher()
        .sink(receiveCompletion: { completion in
            interactorExpectation.fulfill()
            switch completion {
            case .finished:
                break
            case .failure(let error):
                XCTFail("\(error)")
            }
        }) { spellDTOs in
            XCTAssertTrue(spellDTOs == fakeData)
        }
        .store(in: &cancellableSet)

        waitForExpectations(timeout: 5)
    }

    func test_spellDetail_fetch_no_local_data() {
        let sut = makeSUT()
        let interactorExpectation = expectation(description: "wait for interactor")

        let fakeData = FakeDataFactory.provideFakeSpellDTO()

        FakeNetworkService.spellDetailHandler = {
            return Result.success(fakeData)
        }

        FakeDatabaseService.spellDetailHandler = {
            return Result.failure(DatabaseClientError.noMatchedEntity)
        }

        sut.spellDetailsPublisher(for: "/api/spells/fake")
        .sink(receiveCompletion: { completion in
            interactorExpectation.fulfill()
            switch completion {
            case .finished:
                break
            case .failure(let error):
                XCTFail("\(error)")
            }
        }) { spellDTO in
            XCTAssertTrue(spellDTO == fakeData)
        }
        .store(in: &cancellableSet)

        waitForExpectations(timeout: 5)
    }

    func test_spellDetail_fetch_from_local_data() {
        let sut = makeSUT()
        let interactorExpectation = expectation(description: "wait for interactor")

        let fakeData = FakeDataFactory.provideFakeSpellDTO()

        FakeNetworkService.spellDetailHandler = {
            XCTFail("Should't call network in thic case")
            return Result.success(fakeData)
        }

        FakeDatabaseService.spellDetailHandler = {
            Result.success(fakeData)
        }

        sut.spellDetailsPublisher(for: "/api/spells/fake")
        .sink(receiveCompletion: { completion in
            interactorExpectation.fulfill()
            switch completion {
            case .finished:
                break
            case .failure(let error):
                XCTFail("\(error)")
            }
        }) { spellDTO in
            XCTAssertTrue(spellDTO == fakeData)
        }
        .store(in: &cancellableSet)

        waitForExpectations(timeout: 5)
    }
    
    private func makeSUT() -> Interactor {
        let fakeDatabaseService = FakeDatabaseService()
        let fakeNetworkService = FakeNetworkService()
        let fakeRefinementsService = FakeRefinementsService()
        return InteractorImpl(databaseService: fakeDatabaseService, networkService: fakeNetworkService, refinementsService: fakeRefinementsService)
    }
}
