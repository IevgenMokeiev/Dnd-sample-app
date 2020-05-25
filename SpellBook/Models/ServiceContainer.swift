//
//  ServiceContainer.swift
//  SpellBookApp
//
//  Created by Yevhen Mokeiev on 4/18/19.
//  Copyright © 2019 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import UIKit
import Combine

/// Provides services
/// If data is requested, tries to get it from the database service
/// If it's not available, fallback to network service
struct ServiceContainer {
    let databaseService: DatabaseService
    let networkService: NetworkService
    let refinementsService: RefinementsService

    init() {
        let translationServiceImpl = TranslationServiceImpl()
        let coreDataStackImpl = CoreDataStackImpl()
        let databaseClientImpl = DatabaseClientImpl(coreDataStack: coreDataStackImpl)
        self.databaseService = DatabaseServiceImpl(databaseClient: databaseClientImpl, translationService: translationServiceImpl)
        self.networkService = NetworkServiceImpl(networkClient: NetworkClientImpl())
        self.refinementsService = RefinementsServiceImpl()

        if CommandLine.arguments.contains("enable-testing") {
            coreDataStackImpl.cleanupStack()
        }
    }
    
    func spellListPublisher() -> SpellPublisher {
        return databaseService.spellListPublisher()
            .mapError { $0 as Error }
            .catch { (error) -> SpellPublisher in
                print("Could not retrieve. \(error)")

                let downloadPublisher = self.networkService.spellListPublisher()
                .receive(on: RunLoop.main)
                .mapError { $0 as Error }
                .map({ (spellDTOs) -> [SpellDTO] in
                    self.databaseService.saveSpellList(spellDTOs)
                    return spellDTOs
                })
                .eraseToAnyPublisher()

                return downloadPublisher
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func spellDetailsPublisher(for path: String) -> SpellDetailPublisher {
        return databaseService.spellDetailsPublisher(for: path)
            .mapError { $0 as Error }
            .catch { (error) -> SpellDetailPublisher in
                print("Could not retrieve. \(error)")

                let downloadPublisher = self.networkService.spellDetailPublisher(for: path)
                .receive(on: RunLoop.main)
                .mapError { $0 as Error }
                .map({ (spellDTO) -> SpellDTO in
                    self.databaseService.saveSpellDetails(spellDTO)
                    return spellDTO
                })
                .eraseToAnyPublisher()

                return downloadPublisher
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func favoritesPublisher() -> SpellPublisher {
        return databaseService.favoritesPublisher()
            .mapError { $0 as Error }
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
