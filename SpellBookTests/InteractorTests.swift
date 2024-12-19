//
//  InteractorTests.swift
//  SpellBookTests
//
//  Created by Yevhen Mokeiev on 22.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Combine
@testable import SpellBook
import XCTest

class InteractorTests: XCTestCase {
    private var cancellableSet: Set<AnyCancellable> = []

    func test_spellList_fetch_no_local_data() {
        let sut = makeSUT()
        let interactorExpectation = expectation(description: "wait for interactor")

        let fakeData = FakeDataFactory.provideFakeSpellListDTO()

        NetworkServiceMock.spellListHandler = {
            Result.success(fakeData)
        }

        DatabaseServiceMock.spellListHandler = {
            Result.failure(.database(.noData))
        }

        sut.spellListPublisher
            .sink(receiveCompletion: { completion in
                interactorExpectation.fulfill()
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    XCTFail("\(error)")
                }
            }) { spellDTOs in
                XCTAssertEqual(spellDTOs, fakeData)
            }
            .store(in: &cancellableSet)

        waitForExpectations(timeout: 5)
    }

    func test_spellList_fetch_from_local_data() {
        let sut = makeSUT()
        let interactorExpectation = expectation(description: "wait for interactor")

        let fakeData = FakeDataFactory.provideFakeSpellListDTO()

        NetworkServiceMock.spellListHandler = {
            Result.failure(.network(.decodingFailed))
        }

        DatabaseServiceMock.spellListHandler = {
            Result.success(fakeData)
        }

        sut.spellListPublisher
            .sink(receiveCompletion: { completion in
                interactorExpectation.fulfill()
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    XCTFail("\(error)")
                }
            }) { spellDTOs in
                XCTAssertEqual(spellDTOs, fakeData)
            }
            .store(in: &cancellableSet)

        waitForExpectations(timeout: 5)
    }

    func test_spellDetail_fetch_no_local_data() {
        let sut = makeSUT()
        let interactorExpectation = expectation(description: "wait for interactor")

        let fakeData = FakeDataFactory.provideFakeSpellDTO()

        NetworkServiceMock.spellDetailHandler = {
            Result.success(fakeData)
        }

        DatabaseServiceMock.spellDetailHandler = {
            Result.failure(.database(.noMatchedEntity))
        }

        sut.spellDetailsPublisher(for: "/api/spells/fake")
            .sink(receiveCompletion: { completion in
                interactorExpectation.fulfill()
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    XCTFail("\(error)")
                }
            }) { spellDTO in
                XCTAssertEqual(spellDTO, fakeData)
            }
            .store(in: &cancellableSet)

        waitForExpectations(timeout: 5)
    }

    func test_spellDetail_fetch_from_local_data() {
        let sut = makeSUT()
        let interactorExpectation = expectation(description: "wait for interactor")

        let fakeData = FakeDataFactory.provideFakeSpellDTO()

        NetworkServiceMock.spellDetailHandler = {
            Result.failure(.network(.decodingFailed))
        }

        DatabaseServiceMock.spellDetailHandler = {
            Result.success(fakeData)
        }

        sut.spellDetailsPublisher(for: "/api/spells/fake")
            .sink(receiveCompletion: { completion in
                interactorExpectation.fulfill()
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    XCTFail("\(error)")
                }
            }) { spellDTO in
                XCTAssertEqual(spellDTO, fakeData)
            }
            .store(in: &cancellableSet)

        waitForExpectations(timeout: 5)
    }

    private func makeSUT() -> Interactor {
        let fakeDatabaseService = DatabaseServiceMock()
        let fakeNetworkService = NetworkServiceMock()
        let fakeRefinementsService = RefinementsServiceMock()
        return InteractorImpl(databaseService: fakeDatabaseService, networkService: fakeNetworkService, refinementsService: fakeRefinementsService)
    }
}
