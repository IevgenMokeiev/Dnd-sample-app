//
//  SpellProviderService.swift
//  SpellBook
//
//  Created by Yevhen Mokeiev on 25.05.2020.
//  Copyright © 2020 Yevhen Mokeiev. All rights reserved.
//

import Foundation

/// Service responsible for data providing
/// If data is requested, tries to get it from the database service
/// If it's not available, fallback to network service
protocol SpellProviderService {
    func spellListPublisher() -> SpellPublisher
    func spellDetailsPublisher(for path: String) -> SpellDetailPublisher
    func favoritesPublisher() -> FavoritesPublisher
    func saveSpellDetails(_ spellDTO: SpellDTO)
    func createSpell(_ spellDTO: SpellDTO)
}

class SpellProviderServiceImpl: SpellProviderService {

    let databaseService: DatabaseService
    let networkService: NetworkService

    init(databaseService: DatabaseService, networkService: NetworkService) {
        self.databaseService = databaseService
        self.networkService = networkService
    }

    func spellListPublisher() -> SpellPublisher {
        return databaseService.spellListPublisher()
            .mapError { $0 as Error }
            .catch { (error) -> SpellPublisher in
                print("Could not retrieve. \(error)")

                let downloadPublisher = self.networkService.spellListPublisher()
                .receive(on: RunLoop.main)
                .mapError { $0 as Error }
                .map { (spellDTOs) -> [SpellDTO] in
                    self.databaseService.saveSpellList(spellDTOs)
                    return spellDTOs
                }
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
                .map { (spellDTO) -> SpellDTO in
                    self.databaseService.saveSpellDetails(spellDTO)
                    return spellDTO
                }
                .eraseToAnyPublisher()

                return downloadPublisher
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func favoritesPublisher() -> FavoritesPublisher {
        return databaseService.favoritesPublisher()
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func saveSpellDetails(_ spellDTO: SpellDTO) {
        self.databaseService.saveSpellDetails(spellDTO)
    }

    func createSpell(_ spellDTO: SpellDTO) {
        self.databaseService.createSpell(spellDTO)
    }
}
