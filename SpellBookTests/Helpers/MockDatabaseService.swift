//
//  MockDatabaseService.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 22.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

@testable import SpellBook

final class MockDatabaseService: DatabaseServiceProtocol {
    let mockSpellList: [SpellDTO]
    let mockFavorites: [SpellDTO]
    let mockSpellDetails: SpellDTO
    
    init(mockSpellList: [SpellDTO], mockFavorites: [SpellDTO], mockSpellDetails: SpellDTO) {
        self.mockSpellList = mockSpellList
        self.mockFavorites = mockFavorites
        self.mockSpellDetails = mockSpellDetails
    }

    func getSpellList() async throws -> [SpellDTO] {
        mockSpellList
    }
    func getFavorites() async throws -> [SpellDTO] {
        mockFavorites
    }
    func getSpellDetails(for path: String) async throws -> SpellDTO {
        mockSpellDetails
    }
    func saveSpellList(_ spellDTOs: [SpellDTO]) async {}
    func saveSpellDetails(_ spellDTO: SpellDTO) async {}
    func createSpell(_ spellDTO: SpellDTO) async {}
}
