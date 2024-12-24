//
//  DatabaseServiceTests.swift
//  SpellBookTests
//
//  Created by Yevhen Mokeiev on 13.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

@testable import SpellBook
import Testing

@Suite
final class DatabaseServiceTests {

    @Test
    func whenFetchSpellList_thenReturnsExpectedResult() async throws {
        let mockSpellList = FakeDataFactory.provideFakeSpellListDTO()
        let sut = makeSUT(fetchedRecords: mockSpellList)
        let spellList = try await sut.getSpellList()
        #expect(spellList == mockSpellList)
    }

    @Test
    func whenFetchSpell_thenReturnsExpectedResult() async throws {
        let mockSpell = FakeDataFactory.provideFakeSpellDTO()
        let sut = makeSUT(fetchedRecords: [mockSpell])
        let spell = try await sut.getSpellDetails(for: "path")
        #expect(spell == mockSpell)
    }

    @Test
    func whenFetchWithNoFavorites_thenReturnsEmptyFavorites() async throws {
        let mockFavorites = FakeDataFactory.provideFakeFavoritesListDTO()
        let sut = makeSUT(fetchedRecords: mockFavorites)
        let favorites = try await sut.getFavorites()
        #expect(favorites == mockFavorites)
    }

    @Test
    func whenFetchWithFavorites_thenReturnsFavorites() async throws {
        let mockFavorites = FakeDataFactory.provideFakeFavoritesListDTO()
        let sut = makeSUT(fetchedRecords: mockFavorites)
        let favorites = try await sut.getFavorites()
        #expect(favorites == mockFavorites)
    }
    
    private func makeSUT(fetchedRecords: [SpellDTO]) -> DatabaseService {
        let client = MockDatabaseClient(mockFetchedRecords: fetchedRecords)
        return DatabaseService(databaseClient: client)
    }
}
