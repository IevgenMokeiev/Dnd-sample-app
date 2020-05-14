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
    func retrieveSpellList() -> AnyPublisher<[SpellDTO], Error>
    func retrieveSpellDetails(spell: SpellDTO) -> AnyPublisher<SpellDTO, Error>
}

class DataLayerImpl: DataLayer {
    private var databaseService: DatabaseService
    private var networkService: NetworkService

    init(databaseService: DatabaseService, networkService: NetworkService) {
        self.databaseService = databaseService
        self.networkService = networkService
    }
    
    func retrieveSpellList() -> AnyPublisher<[SpellDTO], Error> {
        let downloadPublisher = networkService.downloadSpellList()
            .mapError { $0 as Error }
            .flatMap { self.databaseService.saveDownloadedSpellList($0)
                .mapError { $0 as Error }
                .eraseToAnyPublisher()

        }
        .eraseToAnyPublisher()

        return databaseService.fetchSpellList()
            .map { self.sortedSpells(spells: $0) }
            .mapError { $0 as Error }
            .catch { _ in downloadPublisher }
            .map { self.sortedSpells(spells: $0) }
            .eraseToAnyPublisher()
    }

    func retrieveSpellDetails(spell: SpellDTO) -> AnyPublisher<SpellDTO, Error> {
        let downloadPublisher = networkService.downloadSpell(with: spell.path)
            .mapError { $0 as Error }
            .flatMap { self.databaseService.saveDownloadedSpell($0).mapError { $0 as Error }.eraseToAnyPublisher() }
            .eraseToAnyPublisher()

        return databaseService.fetchSpell(by: spell.name)
            .mapError { $0 as Error }
            .catch { _ in downloadPublisher }
            .eraseToAnyPublisher()
    }

    func sortedSpells(spells: [SpellDTO]) -> [SpellDTO] {
        return spells.sorted(by: { $0.name.caseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending })
    }
}
