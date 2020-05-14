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

public enum DataLayerError: Error {
    case generalError
}

protocol DataLayer {
    func retrieveSpellList() -> AnyPublisher<[SpellDTO], DataLayerError>
    func retrieveSpellDetails(spell: SpellDTO) -> AnyPublisher<SpellDTO, DataLayerError>
}

class DataLayerImpl: DataLayer {
    private var databaseService: DatabaseService
    private var networkService: NetworkService

    init(databaseService: DatabaseService, networkService: NetworkService) {
        self.databaseService = databaseService
        self.networkService = networkService
    }
    
    func retrieveSpellList() -> AnyPublisher<[SpellDTO], DataLayerError> {

        let downloadPublisher = networkService.downloadSpellList()
            .map{ self.sortedSpells(spells: $0) }
//            .map { self.databaseService.saveDownloadedSpellList($0) }
            .mapError { _ in DataLayerError.generalError
            }
            .eraseToAnyPublisher()

        return databaseService.fetchSpellList()
        .map { self.sortedSpells(spells: $0) }
        .mapError { _ in DataLayerError.generalError
            }
        .catch { _ in downloadPublisher }
        .eraseToAnyPublisher()
    }

    func retrieveSpellDetails(spell: SpellDTO) -> AnyPublisher<SpellDTO, DataLayerError> {
        let downloadPublisher = networkService.downloadSpell(with: spell.path)
        //            .map { self.databaseService.saveDownloadedSpell($0) }
                    .mapError { _ in DataLayerError.generalError
                    }
                    .eraseToAnyPublisher()

        return databaseService.fetchSpell(by: spell.name)
        .mapError { _ in DataLayerError.generalError
            }
        .catch { _ in downloadPublisher }
        .eraseToAnyPublisher()
    }

    func sortedSpells(spells: [SpellDTO]) -> [SpellDTO] {
        return spells.sorted(by: { $0.name.caseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending })
    }
}
