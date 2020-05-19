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
    func spellListPublisher(for searchTerm: String, sort: Sort) -> SpellListPublisher
    func spellDetailsPublisher(for path: String) -> SpellDetailPublisher
}

class DataLayerImpl: DataLayer {
    private var databaseService: DatabaseService
    private var networkService: NetworkService

    init(databaseService: DatabaseService, networkService: NetworkService) {
        self.databaseService = databaseService
        self.networkService = networkService
    }
    
    func spellListPublisher(for searchTerm: String, sort: Sort) -> SpellListPublisher {
        let downloadPublisher = networkService.spellListPublisher()
            .mapError { $0 as Error }
            .flatMap {
                self.databaseService.saveSpellListPublisher(for: $0)
                .mapError { $0 as Error }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()

        return databaseService.spellListPublisher()
            .mapError { $0 as Error }
            .catch { _ in downloadPublisher }
            .map { self.sortedSpells(spells: $0, sort: sort) }
            .map { self.filteredSpells(spells: $0, by: searchTerm) }
            .eraseToAnyPublisher()
    }

    func spellDetailsPublisher(for path: String) -> SpellDetailPublisher {
        let downloadPublisher = networkService.spellDetailPublisher(for: path)
            .mapError { $0 as Error }
            .flatMap {
                self.databaseService.saveSpellDetailsPublisher(for: $0)
                .mapError { $0 as Error }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()

        return databaseService.spellDetailsPublisher(for: path)
            .mapError { $0 as Error }
            .catch { _ in downloadPublisher }
            .eraseToAnyPublisher()
    }

    // MARK: - Private
    func sortedSpells(spells: [SpellDTO], sort: Sort) -> [SpellDTO] {
        let sortRule: (SpellDTO, SpellDTO) -> Bool = {
            switch sort {
            case .name:
                return $0.name.caseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending
            case .level:
                return ($0.level ?? 0) < ($1.level ?? 0)
            }
        }

        return spells.sorted(by: sortRule)
    }

    func filteredSpells(spells: [SpellDTO], by searchTerm: String) -> [SpellDTO] {
        if searchTerm.isEmpty {
            return spells
        } else {
            return spells.filter { $0.name.starts(with: searchTerm) }
        }
    }
}
