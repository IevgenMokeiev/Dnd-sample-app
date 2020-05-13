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
            .map{ self.sortedSpells(spells: $0) }
            .map{ self.databaseService.saveDownloadedSpellList($0) }

        return databaseService.fetchSpellList()
        .map { self.sortedSpells(spells: $0) }
        .catch { _ in downloadPublisher }
    }

    func retrieveSpellDetails(_ spell: SpellDTO, completionHandler: @escaping (_ result: Result<SpellDTO, Error>) -> Void) {
        let fetchResult = databaseService.fetchSpell(by: spell.name)

        switch fetchResult {
        case .success(let spell):
            completionHandler(.success(spell))
        case .failure(_):
            // need to download the data first
            networkService.downloadSpell(with: spell.path)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }) { spellDTO in
                    self.databaseService.saveDownloadedSpell(spellDTO)
                    completionHandler(.success(spellDTO)
                    )
            }
            .store(in: &bag)
        }
    }

    func sortedSpells(spells: [SpellDTO]) -> [SpellDTO] {
        return spells.sorted(by: { $0.name.caseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending })
    }
}
