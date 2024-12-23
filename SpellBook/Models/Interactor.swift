//
//  Interactor.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 4/18/19.
//  Copyright © 2019 Yevhen Mokeiev. All rights reserved.
//

import Combine
import Foundation
import UIKit

/// Provides data to UI using services.
/// Uses services to provide requested data
/// If data is requested, tries to get it from the database service
/// If it's not available, fallback to network service
protocol InteractorProtocol {
    func getSpellList() async throws -> [SpellDTO]
    func getFavorites() async throws -> [SpellDTO]
    func getSpellDetails(for path: String) async throws -> SpellDTO
    func refine(spells: [SpellDTO], sort: Sort, searchTerm: String) -> [SpellDTO]
    func saveSpell(_ spellDTO: SpellDTO) async throws
}

class Interactor: InteractorProtocol {
    private var databaseService: DatabaseService
    private var networkService: NetworkService
    private var refinementsService: RefinementsService

    init(databaseService: DatabaseService, networkService: NetworkService, refinementsService: RefinementsService) {
        self.databaseService = databaseService
        self.networkService = networkService
        self.refinementsService = refinementsService
    }

    func getSpellList() async throws -> [SpellDTO] {
        do {
            let localSpellList = try await databaseService.getSpellList()
            return localSpellList
        } catch {
            let remoteSpellList = try await networkService.getSpellList()
            await databaseService.saveSpellList(remoteSpellList)
            return remoteSpellList
        }
    }

    func getFavorites() async throws -> [SpellDTO] {
        try await databaseService.getFavorites()
    }

    func getSpellDetails(for path: String) async throws -> SpellDTO {
        do {
            let localSpell = try await databaseService.getSpellDetails(for: path)
            return localSpell
        } catch {
            let remoteSpell = try await networkService.getSpellDetails(for: path)
            await databaseService.saveSpellDetails(remoteSpell)
            return remoteSpell
        }
    }

    func refine(spells: [SpellDTO], sort: Sort, searchTerm: String) -> [SpellDTO] {
        return refinementsService.refineSpells(spells: spells, sort: sort, searchTerm: searchTerm)
    }

    func saveSpell(_ spell: SpellDTO) async {
        await databaseService.saveSpellDetails(spell)
    }
}
