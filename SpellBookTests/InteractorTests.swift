//
//  InteractorTests.swift
//  SpellBookTests
//
//  Created by Yevhen Mokeiev on 22.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Combine
@testable import SpellBook
import Testing

@Suite
final class InteractorTests {
    private var cancellableSet: Set<AnyCancellable> = []
    private var mockDatabaseService: MockDatabaseService!
    private var mockNetworkService: MockNetworkService!
    
    init() {
        mockDatabaseService = MockDatabaseService()
        mockNetworkService = MockNetworkService()
    }
    
    deinit {
        mockDatabaseService = nil
        mockNetworkService = nil
    }

    @Test
    func whenFetchRemoteData_thenSpellListReturnsExpectedValue() async {
        let sut = makeSUT()
        let fakeData = FakeDataFactory.provideFakeSpellListDTO()

        mockNetworkService.spellListHandler = {
            Result.success(fakeData)
        }

        mockDatabaseService.spellListHandler = {
            Result.failure(.database(.noData))
        }
        
        let (spy, cancellable) = await sut.spellListPublisher.spy()
        cancellable.store(in: &cancellableSet)
        #expect(spy.values.first == fakeData)
    }

    @Test
    func whenFetchLocalData_thenSpellListReturnsExpectedValue() async {
        let sut = makeSUT()

        let fakeData = FakeDataFactory.provideFakeSpellListDTO()

        mockNetworkService.spellListHandler = {
            Result.failure(.network(.decodingFailed))
        }

        mockDatabaseService.spellListHandler = {
            Result.success(fakeData)
        }

        let (spy, cancellable) = await sut.spellListPublisher.spy()
        cancellable.store(in: &cancellableSet)
        #expect(spy.values.first == fakeData)
    }

    @Test
    func whenFetchRemoteData_thenSpellDetailReturnsExpectedValue() async {
        let sut = makeSUT()

        let fakeData = FakeDataFactory.provideFakeSpellDTO()

        mockNetworkService.spellDetailHandler = {
            Result.success(fakeData)
        }

        mockDatabaseService.spellDetailHandler = {
            Result.failure(.database(.noMatchedEntity))
        }

        let (spy, cancellable) = await sut.spellDetailsPublisher(for: "/api/spells/fake").spy()
        cancellable.store(in: &cancellableSet)
        #expect(spy.values.first == fakeData)
    }

    @Test
    func whenFetchLocalData_thenSpellDetailReturnsExpectedValue() async {
        let sut = makeSUT()
        let fakeData = FakeDataFactory.provideFakeSpellDTO()

        mockNetworkService.spellDetailHandler = {
            Result.failure(.network(.decodingFailed))
        }

        mockDatabaseService.spellDetailHandler = {
            Result.success(fakeData)
        }

        let (spy, cancellable) = await sut.spellDetailsPublisher(for: "/api/spells/fake").spy()
        cancellable.store(in: &cancellableSet)
        #expect(spy.values.first == fakeData)
    }

    private func makeSUT() -> Interactor {
        InteractorImpl(databaseService: mockDatabaseService, networkService: mockNetworkService, refinementsService: StubRefinementsService())
    }
}
