//
//  MockDatabaseClient.swift
//  SpellBook
//
//  Created by Eugene Mokeiev on 24.12.2024.
//  Copyright © 2024 Ievgen. All rights reserved.
//

@testable import SpellBook
import Foundation

final class MockDatabaseClient: DatabaseClientProtocol {
    let mockFetchedRecords: [SpellDTO]
    
    init(mockFetchedRecords: [SpellDTO]) {
        self.mockFetchedRecords = mockFetchedRecords
    }
    
    func fetchRecords(predicate: Predicate<Spell>?) async throws -> [SpellDTO] {
        mockFetchedRecords
    }
    
    func createRecord(spellDTO: SpellDTO) async throws {}
    
    func updateRecord(predicate: Predicate<Spell>?, spellDTO: SpellDTO) async throws {}
    
    func save() async {}
}
