//
//  DatabaseService.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 4/19/19.
//  Copyright © 2019 Yevhen Mokeiev. All rights reserved.
//

import Combine
import CoreData
import Foundation

typealias SaveClosure = (SpellDTO) -> Void

protocol DatabaseService {
    func getSpellList() async throws -> [SpellDTO]
    func getFavorites() async throws -> [SpellDTO]
    func getSpellDetails(for path: String) async throws -> SpellDTO
    func saveSpellList(_ spellDTOs: [SpellDTO]) async
    func saveSpellDetails(_ spellDTO: SpellDTO) async
    func createSpell(_ spellDTO: SpellDTO) async
}

final class DatabaseServiceImpl: DatabaseService {
    private let databaseClient: DatabaseClient

    init(databaseClient: DatabaseClient) {
        self.databaseClient = databaseClient
    }

    func getSpellList() async throws -> [SpellDTO] {
        try await databaseClient.fetchRecords(predicate: nil)
    }

    func getFavorites() async throws -> [SpellDTO] {
        try await databaseClient.fetchRecords(
            predicate: #Predicate { $0.isFavorite == true }
        )
    }

    func getSpellDetails(for path: String) async throws -> SpellDTO {
        let predicate: Predicate<Spell> = #Predicate { $0.path == path }
        guard let matchedSpell = try await databaseClient.fetchRecords(predicate: predicate).first,
                matchedSpell.isPopulated else {
            throw CustomError.database(.noMatchedEntity)
        }
        return matchedSpell
    }

    func saveSpellList(_ spellDTOs: [SpellDTO]) async {
        for spellDTO in spellDTOs {
            try? await databaseClient.createRecord(spellDTO: spellDTO)
        }
        await databaseClient.save()
    }

    func saveSpellDetails(_ spellDTO: SpellDTO) async {
        let predicate: Predicate<Spell> = #Predicate { $0.path == spellDTO.path }
        try? await databaseClient.updateRecord(predicate: predicate, spellDTO: spellDTO)
        await databaseClient.save()
    }

    func createSpell(_ spellDTO: SpellDTO) async {
        try? await databaseClient.createRecord(spellDTO: spellDTO)
        await databaseClient.save()
    }
}
