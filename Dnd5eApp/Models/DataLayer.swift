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

/// Responsible for communication between UI and Data layers.
/// Uses services to provide requested data
/// If data is requested, tries to get it from the database service
/// If it's not available, fallback to network service
protocol DataLayer {
    func spellListPublisher() -> SpellPublisher
    func spellDetailsPublisher(for path: String) -> SpellDetailPublisher
    func favoritesPublisher() -> SpellPublisher
    func refineSpells(spells: [SpellDTO], sort: Sort, searchTerm: String) -> [SpellDTO]
}

class DataLayerImpl: DataLayer {
    private var databaseService: DatabaseService
    private var networkService: NetworkService
    private var refinementsService: RefinementsService

    init(databaseService: DatabaseService, networkService: NetworkService, refinementsService: RefinementsService) {
        self.databaseService = databaseService
        self.networkService = networkService
        self.refinementsService = refinementsService
    }

    func refineSpells(spells: [SpellDTO], sort: Sort, searchTerm: String) -> [SpellDTO] {
        return self.refinementsService.refineSpells(spells: spells, sort: sort, searchTerm: searchTerm)
    }
    
    func spellListPublisher() -> SpellPublisher {
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
            .catch { (error) -> SpellPublisher in
                print("Could not retrieve. \(error)")
                return downloadPublisher
            }
            .receive(on: RunLoop.main)
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
            .catch { (error) -> SpellDetailPublisher in
                print("Could not retrieve. \(error)")
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
}
