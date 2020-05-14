//
//  DataLayer.swift
//  Dnd5eApp
//
//  Created by Yevhen Mokeiev on 4/18/19.
//  Copyright © 2019 Yevhen Mokeiev. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Combine

protocol DataLayer {
    func spellListPublisher() -> AnyPublisher<[SpellDTO], Error>
    func spellDetailsPublisher(for spell: SpellDTO) -> AnyPublisher<SpellDTO, Error>
}

class DataLayerImpl: DataLayer {
    private var databaseService: DatabaseService
    private var networkService: NetworkService

    init(databaseService: DatabaseService, networkService: NetworkService) {
        self.databaseService = databaseService
        self.networkService = networkService
    }
    
    func spellListPublisher() -> AnyPublisher<[SpellDTO], Error> {
        let downloadPublisher = networkService.spellListPublisher()
            .mapError { $0 as Error }
            .flatMap { self.databaseService.saveSpellListPublisher(for: $0)
                .mapError { $0 as Error }
                .eraseToAnyPublisher()

        }
        .eraseToAnyPublisher()

        return databaseService.spellListPublisher()
            .map { self.sortedSpells(spells: $0) }
            .mapError { $0 as Error }
            .catch { _ in downloadPublisher }
            .map { self.sortedSpells(spells: $0) }
            .eraseToAnyPublisher()
    }

    func spellDetailsPublisher(for spell: SpellDTO) -> AnyPublisher<SpellDTO, Error> {
        let downloadPublisher = networkService.spellDetailPublisher(for: spell.path)
            .mapError { $0 as Error }
            .flatMap { self.databaseService.saveSpellDetailsPublisher(for: $0).mapError { $0 as Error }.eraseToAnyPublisher() }
            .eraseToAnyPublisher()

        return databaseService.spellDetailsPublisher(for: spell.name)
            .mapError { $0 as Error }
            .catch { _ in downloadPublisher }
            .eraseToAnyPublisher()
    }

    func sortedSpells(spells: [SpellDTO]) -> [SpellDTO] {
        return spells.sorted(by: { $0.name.caseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending })
    }
}
