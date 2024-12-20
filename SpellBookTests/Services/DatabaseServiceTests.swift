//
//  DatabaseServiceTests.swift
//  SpellBookTests
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Combine
import CoreData
@testable import SpellBook
import Testing

@Suite
final class DatabaseServiceTests {
    
    private var coreDataStack: StubCoreDataStack!
    private var context: NSManagedObjectContext!
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        coreDataStack = StubCoreDataStack()
        context = coreDataStack.persistentContainer.viewContext
    }
    
    deinit {
        coreDataStack = nil
        context = nil
        cancellableSet.removeAll()
    }

    @Test
    func whenFetchSpellList_thenReturnsExpectedResult() throws {
        let sut = makeSUT()
        let context = try #require(context)
        _ = FakeDataFactory.provideFakeSpellList(context: context)
        sut.spellListPublisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    Issue.record("\(error)")
                }
            }) { spellDTOs in
                #expect(spellDTOs == FakeDataFactory.provideFakeSpellListDTO())
            }
            .store(in: &cancellableSet)
    }

    @Test
    func whenFetchSpell_thenReturnsExpectedResult() throws {
        let sut = makeSUT()
        let context = try #require(context)
        let spell = FakeDataFactory.provideFakeSpell(context: context)
        sut.spellDetailsPublisher(for: spell.path!)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    Issue.record("\(error)")
                }
            }) { spellDTO in
                #expect(spellDTO == FakeDataFactory.provideFakeSpellDTO())
            }
            .store(in: &cancellableSet)
    }

    @Test
    func whenFetchWithNoFavorites_thenReturnsEmptyFavorites() throws {
        let sut = makeSUT()
        let context = try #require(context)
        _ = FakeDataFactory.provideFakeSpellList(context: context)
        sut.favoritesPublisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    Issue.record("\(error)")
                }
            }) { spellDTOs in
                #expect(spellDTOs.isEmpty)
            }
            .store(in: &cancellableSet)
    }

    @Test
    func whenFetchWithFavorites_thenReturnsFavorites() throws {
        let sut = makeSUT(testFavorites: true)
        let context = try #require(context)
        _ = FakeDataFactory.provideFakeFavoritesList(context: context)
        sut.favoritesPublisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    Issue.record("\(error)")
                }
            }) { spellDTOs in
                #expect(spellDTOs ==  FakeDataFactory.provideFakeFavoritesListDTO())
            }
            .store(in: &cancellableSet)
    }
    
    private func makeSUT(testFavorites: Bool = false) -> DatabaseServiceImpl {
        return DatabaseServiceImpl(
            databaseClient: DatabaseClientImpl(coreDataStack: coreDataStack),
            translationService: MockTranslationService(testFavorites: testFavorites)
        )
    }
}
