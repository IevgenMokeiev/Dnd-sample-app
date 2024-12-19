//
//  Interactor.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 4/18/19.
//  Copyright © 2019 Yevhen Mokeiev. All rights reserved.
//

import Combine
import CoreData
import Foundation
import UIKit

/// Provides data to UI using services.
/// Uses services to provide requested data
/// If data is requested, tries to get it from the database service
/// If it's not available, fallback to network service
protocol Interactor {
    var spellListPublisher: SpellListPublisher { get }
    var favoritesPublisher: NoErrorSpellListPublisher { get }
    func spellDetailsPublisher(for path: String) -> SpellDetailPublisher
    func refine(spells: [SpellDTO], sort: Sort, searchTerm: String) -> [SpellDTO]
    func saveSpell(_ spell: SpellDTO)
}

class InteractorImpl: Interactor {
    private var databaseService: DatabaseService
    private var networkService: NetworkService
    private var refinementsService: RefinementsService

    init(databaseService: DatabaseService, networkService: NetworkService, refinementsService: RefinementsService) {
        self.databaseService = databaseService
        self.networkService = networkService
        self.refinementsService = refinementsService
    }

    var spellListPublisher: SpellListPublisher {
        let downloadPublisher = networkService.spellListPublisher
            .cacheOutput(service: databaseService)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()

        return databaseService.spellListPublisher
            .fallback(downloadPublisher)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    var favoritesPublisher: NoErrorSpellListPublisher {
        return databaseService.favoritesPublisher
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func spellDetailsPublisher(for path: String) -> SpellDetailPublisher {
        let downloadPublisher = networkService.spellDetailPublisher(for: path)
            .cacheOutput(service: databaseService)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()

        return databaseService.spellDetailsPublisher(for: path)
            .fallback(downloadPublisher)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func refine(spells: [SpellDTO], sort: Sort, searchTerm: String) -> [SpellDTO] {
        return refinementsService.refineSpells(spells: spells, sort: sort, searchTerm: searchTerm)
    }

    func saveSpell(_ spell: SpellDTO) {
        databaseService.saveSpellDetails(spell)
    }
}
