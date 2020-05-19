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
    func spellListPublisher() -> SpellListPublisher
    func spellDetailsPublisher(for path: String) -> SpellDetailPublisher
}

class DataLayerImpl: DataLayer {
    private var databaseService: DatabaseService
    private var networkService: NetworkService

    init(databaseService: DatabaseService, networkService: NetworkService) {
        self.databaseService = databaseService
        self.networkService = networkService
    }
    
    func spellListPublisher() -> SpellListPublisher {
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
            .catch { _ in downloadPublisher }
            .eraseToAnyPublisher()
    }
}
